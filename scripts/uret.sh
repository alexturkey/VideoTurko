#!/usr/bin/env bash
# VideoTurko Linux video uretim betigi (scripts/uret.ps1 karsiligi). DENEYSEL: bakimcilar Linux'ta GPU kosusu yapmadi.
#   Kullanici bildirdi (PR #8, xmtaha): 56 kare RTX 4060 Ti 8 GB. 141/209 kare Linux'ta OLCULMEDI.
# Kurallar uret.ps1 ile BIREBIR: ayni jeton formulu, ayni kare/boyut tavanlari, ayni iki asama esigi, ayni kalite kapisi esikleri
#   (gurultu <= 1,5, orta akis > 0,05, kare sayisi = beklenen), karolu VAE log taramasi, sd-cli cikis kodu raporu.
# Sabitler (kalite): 6 adim, cfg 1, tohum 42, KAROSUZ VAE (--vae-tiling/--temporal-tiling HICBIR ZAMAN eklenmez).
# Cikis kodlari: 0 tamam, 1 hata, 2 kullanim hatasi ya da DUR dosyasi, 5 kalite kapisi RED, 6 kapi calismadi (python/opencv yok).
# Durdurma: <VT_ROOT>/DUR dosyasi olusturun; betik sd-cli'yi kapatir ve DURDU yazar.
# Ortam: VT_ROOT, VT_ENGINE_BIN, VT_MODEL_DIR, VT_PYTHON, VT_GPU_CC / VT_GPU_VRAM (okumayi ezer, test icin), VT_MAX_KARE, VT_MAX_JETON,
#   deneysel (varsayilan KAPALI, UYARI basar): VT_ATTN_BUDGET (0..1, varsayilan 0.05), VT_CHUNK_MB (1..4096, varsayilan 64),
#   VT_MARGIN_MB (1..4096, varsayilan 1; YALNIZ Linux uret.sh, YALNIZ iki asamali kosuda 1. asamanin SD_VRAM_MARGIN_MB payi; uret.ps1'de karsiligi yok; 0 yazmayin) [kullanici bildirdi, PR #31].
set -euo pipefail

# TEK SABIT SAYILAR (uret.ps1 ile ayni):
KARE_SABIT=209        # varsayilan -Kare VE kare tavani
KARE_INIT=192         # --init-img ile en fazla kare
KARE_END_4GB=175      # 8 GB alti kartta --end-img ile en fazla kare
ORTA_KART_UST_MIB=11000   # 8000 ile bu deger arasi = "8 GB sinifi"
JETON_8GB=16320   # 8 GB sinifinda standart disi boyut jeton tavani [kullanici bildirdi, issue #26: RTX 4070 Laptop 16320 gecti; bizce olculmedi]
KUCUK_KART_MIB=8000   # 8 GB kartlar 8151-8192 MiB bildirir (issue #26); bu degerin altindaki (ya da VRAM'i okunamayan) kart "kucuk" sayilir

hata() {   # hata KOD "mesaj" [cikis]: uret.ps1'deki [VT-E-...] imzalariyla ayni kodlar (docs/hata_imzalari.json)
  echo "HATA: [$1] $2" >&2
  exit "${3:-1}"
}
kullanim() { echo "Kullanim: ./uret.sh --istem <dosya.txt> [--kare 56|141|209] [-W 640 -H 384] [--seed 42] [--init-img a.png] [--end-img b.png] [--tek-asama] [--tavan-dk N] [--kuru]"; }
tam_sayi() { [[ "$1" =~ ^-?[0-9]+$ ]]; }
pozitif() { [[ "$1" =~ ^[0-9]+$ && "$1" -gt 0 ]]; }
buyuk_mu() { awk -v a="$1" -v b="$2" 'BEGIN{exit !(a+0 >= b+0)}'; }   # a >= b (ondalik)
kucuk_mu() { awk -v a="$1" -v b="$2" 'BEGIN{exit !(a+0 < b+0)}'; }    # a < b (ondalik)
dogru_yanlis() { if [[ "$1" -eq 1 ]]; then echo True; else echo False; fi; }

ISTEM=""; KARE=0; W=640; H=384; W_VERILDI=0; H_VERILDI=0; SEED=42; INIT_IMG=""; END_IMG=""
TEK_ASAMA=0; KURU=0; KONTROL=0; TAVAN_DK=0

deger() { [[ $# -ge 2 && -n "$2" ]] || { echo "HATA: $1 icin deger gerekir" >&2; kullanim >&2; exit 2; }; }
while [[ $# -gt 0 ]]; do
  case "$1" in
    --istem|-Istem) deger "$@"; ISTEM="$2"; shift 2 ;;
    --kare|-Kare) deger "$@"; KARE="$2"; shift 2 ;;
    -W|--w) deger "$@"; W="$2"; W_VERILDI=1; shift 2 ;;
    -H|--h) deger "$@"; H="$2"; H_VERILDI=1; shift 2 ;;
    --seed|-Seed) deger "$@"; SEED="$2"; shift 2 ;;
    --init-img|-InitImg) deger "$@"; INIT_IMG="$2"; shift 2 ;;
    --end-img|-EndImg) deger "$@"; END_IMG="$2"; shift 2 ;;
    --tek-asama|-TekAsama) TEK_ASAMA=1; shift ;;
    --kuru|-Kuru) KURU=1; shift ;;
    --kontrol|-Kontrol) KONTROL=1; shift ;;
    --tavan-dk|-TavanDk) deger "$@"; TAVAN_DK="$2"; shift 2 ;;
    -h|--help) kullanim; exit 0 ;;
    *) echo "Bilinmeyen parametre: $1" >&2; kullanim >&2; exit 2 ;;
  esac
done

# Sayisal girdiler aritmetiga girmeden dogrulanir (komut enjeksiyonu/yanlis hesap yok)
tam_sayi "$KARE" || hata VT-E-KARE "--kare tam sayi olmali. Verilen: $KARE"
tam_sayi "$W" && tam_sayi "$H" || hata VT-E-BOYUT "-W ve -H tam sayi olmali. Verilen: ${W}x${H}"
tam_sayi "$SEED" || hata VT-E-ISTEM "--seed tam sayi olmali. Verilen: $SEED"
tam_sayi "$TAVAN_DK" || hata VT-E-TAVAN "--tavan-dk tam sayi olmali. Verilen: $TAVAN_DK"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${VT_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
ENGINE_BIN="${VT_ENGINE_BIN:-$ROOT/engine/bin}"
MODEL_DIR="${VT_MODEL_DIR:-$ROOT/model}"
SD_CLI="$ENGINE_BIN/sd-cli"
if [[ -n "${VT_PYTHON:-}" ]]; then PY="$VT_PYTHON"
elif [[ -x "$ROOT/.venv/bin/python" ]]; then PY="$ROOT/.venv/bin/python"
else PY="python3"; fi

# --- GPU bilgisi (yalniz okuma). Birden cok GPU: EN KUCUK VRAM ve EN KUCUK compute capability (uret.ps1 ile ayni temkinli taraf).
GPU_VRAM=-1; GPU_CC=-1; GPU_SAYI=0
if command -v nvidia-smi >/dev/null 2>&1; then
  while IFS= read -r satir; do
    satir="${satir//[[:space:]]/}"
    if [[ "$satir" =~ ^[0-9]+$ && "$satir" -gt 0 ]]; then
      GPU_SAYI=$((GPU_SAYI + 1))
      if [[ "$GPU_VRAM" -lt 0 || "$satir" -lt "$GPU_VRAM" ]]; then GPU_VRAM="$satir"; fi
    fi
  done < <(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null || true)
  cc_ilk=1
  while IFS= read -r satir; do
    satir="${satir//[[:space:]]/}"; satir="${satir//,/.}"
    if [[ "$satir" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
      if [[ "$cc_ilk" -eq 1 ]] || kucuk_mu "$satir" "$GPU_CC"; then GPU_CC="$satir"; fi
      cc_ilk=0
    else
      GPU_CC=-1; break
    fi
  done < <(nvidia-smi --query-gpu=compute_cap --format=csv,noheader,nounits 2>/dev/null || true)
fi
if [[ -n "${VT_GPU_CC:-}" ]]; then
  vcc="${VT_GPU_CC//,/.}"; vcc="${vcc//[[:space:]]/}"
  if [[ "$vcc" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then GPU_CC="$vcc"; else echo "UYARI: VT_GPU_CC='$VT_GPU_CC' sayi olarak okunamadi, yok sayildi (ornek: 8.9 ya da 8,9)"; fi
fi
if [[ -n "${VT_GPU_VRAM:-}" ]]; then
  vv="${VT_GPU_VRAM//,/.}"; vv="${vv//[[:space:]]/}"; vv="${vv%%.*}"
  if pozitif "$vv"; then GPU_VRAM="$vv"; else echo "UYARI: VT_GPU_VRAM='$VT_GPU_VRAM' sayi (MiB) olarak okunamadi, yok sayildi (ornek: 12282)"; fi
fi
GPU_CC_YAZI="$(awk -v c="$GPU_CC" 'BEGIN{printf "%g", c+0}')"
if [[ "$GPU_SAYI" -gt 1 ]]; then
  echo "bilgi: $GPU_SAYI GPU goruldu; sd-cli CUDA 0'i kullanir. Betik temkinli tarafla karar verir: en kucuk VRAM $GPU_VRAM MiB, en kucuk compute capability $GPU_CC_YAZI. Yalniz tek GPU ile olculdu; karti CUDA_VISIBLE_DEVICES ile secebilirsiniz."
fi

KUCUK_KART=0; ORTA_KART=0
[[ "$GPU_VRAM" -lt "$KUCUK_KART_MIB" ]] && KUCUK_KART=1   # VRAM okunamadiysa (-1) kucuk sayilir (temkinli)
[[ "$KUCUK_KART" -eq 0 && "$GPU_VRAM" -lt "$ORTA_KART_UST_MIB" ]] && ORTA_KART=1
END_KISIT=0; [[ "$KUCUK_KART" -eq 1 ]] && END_KISIT=1   # -EndImg kisiti yalniz kucuk kartta (eski davranis)

# --- varsayilan kare ve dogrulamalar (uret.ps1 ile ayni mesaj kodlari)
KARE_VARSAYILAN=0
if [[ "$KARE" -eq 0 ]]; then
  KARE_VARSAYILAN=1
  if [[ -n "$INIT_IMG" || -n "$END_IMG" ]]; then KARE="$KARE_INIT"; else KARE="$KARE_SABIT"; fi
fi
KARE_END_TAVAN="$KARE_INIT"; [[ "$END_KISIT" -eq 1 ]] && KARE_END_TAVAN="$KARE_END_4GB"
[[ -n "$END_IMG" && "$KARE_VARSAYILAN" -eq 1 ]] && KARE="$KARE_END_TAVAN"

if [[ "$KARE" -lt 5 || $(( (KARE - 5) % 17 )) -ne 0 ]]; then hata VT-E-KARE "Kare sayisi 17k+5 olmali (5, 22, 39, ... en fazla $KARE_SABIT). Verilen: $KARE"; fi
if [[ -n "$INIT_IMG" && "$KARE" -gt "$KARE_INIT" ]]; then hata VT-E-KARE "--init-img ile en fazla $KARE_INIT kare (8,0 sn) desteklenir. Verilen: $KARE"; fi
if [[ -n "$END_IMG" && "$END_KISIT" -eq 1 && "$KARE" -gt "$KARE_END_4GB" ]]; then hata VT-E-KARE "--end-img ile bu kartta (VRAM $GPU_VRAM MiB; 8 GB alti ya da okunamadi) en fazla $KARE_END_4GB kare. Verilen: $KARE"; fi
if [[ -n "$END_IMG" && "$KARE" -gt "$KARE_INIT" ]]; then hata VT-E-KARE "--end-img ile en fazla $KARE_INIT kare desteklenir. Verilen: $KARE"; fi
KARE_TAVAN="$KARE_SABIT"
if [[ -n "${VT_MAX_KARE:-}" ]]; then pozitif "$VT_MAX_KARE" && KARE_TAVAN="$VT_MAX_KARE" || echo "UYARI: VT_MAX_KARE='$VT_MAX_KARE' pozitif tam sayi degil, yok sayildi"; fi
if [[ "$KARE" -gt "$KARE_TAVAN" ]]; then hata VT-E-KARE "Kare sayisi $KARE_TAVAN degerinden buyuk desteklenmiyor (denenmedi). Verilen: $KARE"; fi

if [[ "$W_VERILDI" -ne "$H_VERILDI" ]]; then hata VT-E-BOYUT "-W ve -H birlikte verilmeli. Dikey: -W 384 -H 640. Verilen: ${W}x${H}"; fi
if [[ "$W" -le 0 || "$H" -le 0 || $(( W % 32 )) -ne 0 || $(( H % 32 )) -ne 0 ]]; then hata VT-E-BOYUT "-W ve -H 32'nin kati olmali (motor yukari yuvarlar). Ornek: 640x384, 384x640, 832x480. Verilen: ${W}x${H}"; fi
if [[ $(( W * H )) -lt $(( 640 * 384 )) ]]; then hata VT-E-BOYUT "-W x -H alani en az 640x384 (245760 piksel) olmali: kalite dusurulmez. Verilen: ${W}x${H}"; fi
STANDART=0; [[ "$W" -eq 640 && "$H" -eq 384 ]] && STANDART=1

# Jeton formulu uret.ps1 ile ayni: jeton = (W/32)*(H/32)*latent_kare; latent_kare = ((Kare-5)/17)*5+2 (Kare 5 ise 2)
if [[ "$KARE" -le 5 ]]; then LAT_KARE=2; else LAT_KARE=$(( (KARE - 5) / 17 * 5 + 2 )); fi
JETON=$(( (W / 32) * (H / 32) * LAT_KARE ))
if [[ -n "$END_IMG" ]]; then JETON_TAVAN=12480; elif [[ -n "$INIT_IMG" ]]; then JETON_TAVAN=13680; elif [[ "$ORTA_KART" -eq 1 ]]; then JETON_TAVAN="$JETON_8GB"; else JETON_TAVAN=14880; fi
if [[ -n "${VT_MAX_JETON:-}" ]]; then pozitif "$VT_MAX_JETON" && JETON_TAVAN="$VT_MAX_JETON" || echo "UYARI: VT_MAX_JETON='$VT_MAX_JETON' pozitif tam sayi degil, yok sayildi"; fi
if [[ "$STANDART" -eq 0 && ( "$KUCUK_KART" -eq 1 || "$ORTA_KART" -eq 1 || -n "${VT_MAX_JETON:-}" ) && "$JETON" -gt "$JETON_TAVAN" ]]; then
  hata VT-E-BOYUT "${W}x${H} ve $KARE kare = $JETON jeton; bu kartta tavan $JETON_TAVAN jeton (VRAM $GPU_VRAM MiB). Daha kisa --kare ya da daha kucuk boyut verin; VT_MAX_JETON ile gecici ezilir (sonuc garanti degil)."
fi

[[ -n "$ISTEM" && -f "$ISTEM" ]] || hata VT-E-ISTEM "istem dosyasi yok: ${ISTEM:-<verilmedi>}"
[[ -z "$INIT_IMG" || -f "$INIT_IMG" ]] || hata VT-E-ISTEM "--init-img dosyasi bulunamadi: $INIT_IMG"
[[ -z "$END_IMG" || -f "$END_IMG" ]] || hata VT-E-ISTEM "--end-img dosyasi bulunamadi: $END_IMG"
ISTEM="$(cd "$(dirname "$ISTEM")" && pwd)/$(basename "$ISTEM")"
[[ -z "$INIT_IMG" ]] || INIT_IMG="$(cd "$(dirname "$INIT_IMG")" && pwd)/$(basename "$INIT_IMG")"
[[ -z "$END_IMG" ]] || END_IMG="$(cd "$(dirname "$END_IMG")" && pwd)/$(basename "$END_IMG")"

# --- deneysel anahtarlar: gecersizse varsayilan + UYARI; aktifse UYARI
ATTN="0.05"; CHUNK_MB="64"; VT_AKTIF=""
vt_attn="${VT_ATTN_BUDGET:-${VT_ATTN:-}}"
if [[ -n "$vt_attn" ]]; then
  vt_attn="${vt_attn//,/.}"
  if [[ "$vt_attn" =~ ^[0-9]+(\.[0-9]+)?$ ]] && buyuk_mu 1 "$vt_attn"; then ATTN="$vt_attn"; VT_AKTIF="$VT_AKTIF VT_ATTN_BUDGET=$ATTN"; else echo "UYARI: VT_ATTN_BUDGET='$vt_attn' 0 ile 1 arasi sayi olarak okunamadi, yok sayildi"; fi
fi
vt_chunk="${VT_CHUNK_MB:-${VT_CHUNK:-}}"
if [[ -n "$vt_chunk" ]]; then
  if [[ "$vt_chunk" =~ ^[0-9]+$ && "$vt_chunk" -ge 1 && "$vt_chunk" -le 4096 ]]; then CHUNK_MB="$vt_chunk"; VT_AKTIF="$VT_AKTIF VT_CHUNK_MB=$CHUNK_MB"; else echo "UYARI: VT_CHUNK_MB='$vt_chunk' 1..4096 tam sayi olarak okunamadi, yok sayildi"; fi
fi
# Bellek payi (1. asama): varsayilan olculmus 1; Linux CUDA'da RTX 3060 Laptop 6 GB'ta 209 karede 1. asama 1 ile dustu, 512 ile gecti [kullanici bildirdi, PR #31, 512 her iki asamada denendi; bizce olculmedi]
MARGIN1="1"
vt_marj="${VT_MARGIN_MB:-}"
if [[ -n "$vt_marj" ]]; then
  if [[ "$vt_marj" =~ ^[0-9]+$ && "$vt_marj" -ge 1 && "$vt_marj" -le 4096 ]]; then
    MARGIN1="$vt_marj"; VT_AKTIF="$VT_AKTIF VT_MARGIN_MB=$MARGIN1"
    echo "UYARI: VT_MARGIN_MB yalniz iki asamali kosuda (209 kare gibi) ve yalniz 1. asamada gecerli; tek asamali kosuda etkisizdir"
  else echo "UYARI: VT_MARGIN_MB='$vt_marj' 1..4096 tam sayi olarak okunamadi (0 yazmayin: 0 'ayarsiz' sayilir ve 1024 MB tuzagina duser), yok sayildi"; fi
fi
[[ -z "$VT_AKTIF" ]] || echo "UYARI: [VT-W-DENEYSEL] deneysel VT_* aktif ($VT_AKTIF ); cikti kalite kurallari disina cikabilir, kalite kapisi bunu yakalamaz: olcum/paylasim icin kullanmayin"

# --- iki asama karari (uret.ps1 ile ayni): jeton > 7680, ya da 8 GB alti kartta --end-img
IKI_ASAMA=0
if [[ "$TEK_ASAMA" -eq 0 ]] && [[ "$JETON" -gt 7680 || ( -n "$END_IMG" && "$END_KISIT" -eq 1 ) ]]; then IKI_ASAMA=1; fi

# --- sure tavani (dk): uret.ps1 ile ayni formul = max(30, ceil(80 * Kare / 209 * alan/245760)); --tavan-dk ile ezilir
if [[ "$TAVAN_DK" -le 0 ]]; then
  pay=$(( 80 * KARE * W * H )); payda=$(( 209 * 245760 ))
  TAVAN_DK=$(( (pay + payda - 1) / payda ))
  [[ "$TAVAN_DK" -lt 30 ]] && TAVAN_DK=30
fi

# --- cikti yeri (yalniz ADLAR; klasor --kuru degilken, dogrulamalardan sonra olusur)
TS="$(date +%Y%m%d_%H%M%S)"
RUN_DIR="$ROOT/runs/run_${TS}_k${KARE}"
OUT_AVI="$RUN_DIR/video.avi"
LATENT="$RUN_DIR/latent.bin"
LOG1="$RUN_DIR/sd_asama1.log"
LOG2="$RUN_DIR/sd_asama2.log"

DIT="$MODEL_DIR/minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf"
TE="$MODEL_DIR/qwen3vl_32b_minimax_h3-Q4_K_M.gguf"
VAE="$MODEL_DIR/minimax_h3_sol_vae_fp16.safetensors"
AVAE="$MODEL_DIR/minimax_h3_audio_vae_fp32.safetensors"

# ortak sd-cli argumanlari: uret.ps1 Ortak-Arg ile ayni sira ve deger
ARGS=(-M vid_gen --diffusion-model "$DIT" --llm "$TE" --vae "$VAE" --audio-vae "$AVAE"
  --prompt-file "$ISTEM" -W "$W" -H "$H" --video-frames "$KARE" --fps 24
  --steps 6 --sampling-method euler --sigmas hyperflow-h3-flash-6 --cfg-scale 1.0
  --rng cpu --seed "$SEED" -t 4 --flash-attn "off,diffusion=on"
  --model-args "minimax_h3_attn_chunk_budget=$ATTN"
  --offload-to-cpu --mmap --backend "te=cpu")
[[ -z "$INIT_IMG" ]] || ARGS+=(--init-img "$INIT_IMG")
[[ -z "$END_IMG" ]] || ARGS+=(--end-img "$END_IMG")
ARGS+=(--log-level debug -o "$OUT_AVI")

# ortam: dogrulanmis tarif (uret.ps1 ile ayni degerler; SD_VRAM_MARGIN_MB olculmus 1 (1. asama) ve 256 (2. asama), kart buyuklugune gore OYNATILMAZ;
# tek bilincli ayar: VT_MARGIN_MB yalniz 1. asama, yalniz Linux, yukarida dogrulanir)
if [[ "$IKI_ASAMA" -eq 1 ]]; then
  ENV1=("SD_VRAM_MARGIN_MB=$MARGIN1" SD_H3_EMBED_CUT=1 SD_H3_DROP_QUEUED=1 SD_H3_EVICT_PAST=1
    SD_ATTN_SET_OUT=1 "SD_QKV_CHUNK_MB=$CHUNK_MB" SD_QKV_SET_OUT=1 "SD_MLP_CHUNK_MB=$CHUNK_MB" "SD_VIDEO_LATENT_SAVE=$LATENT")
  ENV2=(SD_VRAM_MARGIN_MB=256 SD_VAE_VRAM_MARGIN_MB=256 SD_CUT_CACHE_HOST_MB=100
    SD_VAE_NO_TILING_FALLBACK=1 SD_VAE_EMBED_CUT=1 "SD_VIDEO_LATENT_LOAD=$LATENT")
else
  ENV1=(SD_VAE_NO_TILING_FALLBACK=1)
  ENV2=()
fi
# cuBLAS f32: compute capability >= 7.0 ve kullanici ayarlamadiysa (sm89'da fp16 >=141 karede tasar: siyah video, issue #1). 6.1 ve okunamayan cc: dokunulmaz.
# (Windows'ta bu kural scripts/kart_tablosu.json'dan okunur; sonuc ayni: cc >= 7.0 siniflari.)
F32=0
if [[ -z "${GGML_CUDA_CUBLAS_COMPUTE_TYPE:-}" ]] && buyuk_mu "$GPU_CC" 7.0 && [[ "$GPU_CC" != "-1" ]]; then
  F32=1; ENV1+=(GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32)
  [[ "$IKI_ASAMA" -eq 1 ]] && ENV2+=(GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32)
fi

if [[ "$KURU" -eq 1 ]]; then
  # YAN ETKISIZ: klasor, dosya, kilit olusmaz; sd-cli/model/python bulunmasa da calisir (yalniz bilgi)
  echo "KURU: kare=$KARE iki_asama=$(dogru_yanlis "$IKI_ASAMA") tavan=${TAVAN_DK}dk cikti=$OUT_AVI"
  echo "KURU bilgi: cozunurluk=${W}x${H} jeton=$JETON tek_asama_elle=$(dogru_yanlis "$TEK_ASAMA") gpu_cc=$GPU_CC_YAZI gpu_vram=$GPU_VRAM MiB f32=$(dogru_yanlis "$F32")"
  echo "ASAMA 1 ortam: ${ENV1[*]}"
  echo "ASAMA 1 komut: sd-cli ${ARGS[*]}"
  if [[ "$IKI_ASAMA" -eq 1 ]]; then
    echo "ASAMA 2 ortam: ${ENV2[*]}"
    echo "ASAMA 2 komut: sd-cli ${ARGS[*]}"
  fi
  eksik=""
  [[ -x "$SD_CLI" ]] || eksik="$eksik sd-cli"
  for f in "$DIT" "$TE" "$VAE" "$AVAE"; do [[ -f "$f" ]] || eksik="$eksik $(basename "$f")"; done
  [[ -z "$eksik" ]] || echo "bilgi: --kuru: su dosyalar yok:$eksik (once ./kur.sh); yalniz bilgi, hicbir sey yazilmadi"
  exit 0
fi

# --- gercek kosu: dosya ve on kosul kontrolleri (GPU isinden ONCE)
[[ -x "$SD_CLI" ]] || hata VT-E-DOSYA "sd-cli bulunamadi: $SD_CLI (once ./kur.sh)"
for f in "$DIT" "$TE" "$VAE" "$AVAE"; do
  [[ -f "$f" ]] || hata VT-E-DOSYA "model dosyasi eksik: $f (once ./kur.sh)"
done
if [[ "$KONTROL" -eq 0 ]]; then
  "$PY" -I -c "import cv2, numpy" >/dev/null 2>&1 || {
    echo "KAPI CALISAMAZ: [VT-E-PY] python + opencv + numpy hazir degil ($PY). Once ./kur.sh calistirin. Video uretilmedi: GPU isi baslamadan durduruldu (cikis 6)." >&2
    exit 6
  }
fi

mkdir -p "$RUN_DIR"
DUR="$ROOT/DUR"
KILIT="$ROOT/runs/gpu.kilit"
if [[ -f "$KILIT" ]]; then
  eski_pid="$(head -n1 "$KILIT" 2>/dev/null | tr -dc '0-9')"
  if [[ -n "$eski_pid" && "$eski_pid" -gt 0 ]] && kill -0 "$eski_pid" 2>/dev/null; then
    hata VT-E-KILIT "GPU baska bir uret.sh tarafindan kullaniliyor (PID $eski_pid). Tek GPU isi calistirin."
  fi
fi
echo "$$" > "$KILIT"
trap 'rm -f "$KILIT"' EXIT

TC_LIB="$ROOT/engine/toolchain/env/lib"
export LD_LIBRARY_PATH="$ENGINE_BIN:$TC_LIB:${LD_LIBRARY_PATH:-}"

vram_ipucu() {   # yalniz hata YORUMLAMA, kesin degil
  local l
  for l in "$LOG1" "$LOG2"; do
    if [[ -f "$l" ]] && grep -Eqi 'failed during weight preparation|ALLOC_FAILED|cannot make enough memory|out of memory|vae decode compute failed|need [0-9.]+ ?MB.{0,60}budget' "$l"; then
      echo "[VT-E-VRAM] VRAM yetmedi olabilir (kesin degil): logda bellek ayirma/agirlik hazirlama hatasi var." >&2
      echo "  Once: diger uygulamalari kapatin, yeniden deneyin. Olmazsa daha kisa deneyin: --kare $(( KARE - 17 )) (17k+5 gridi). Ayrinti: docs/SIK_HATALAR.md A.1" >&2
      return 0
    fi
  done
  return 0
}
log_temiz() {   # karolu VAE geri-dususu ya da bellek hatasi => gecersiz (uret.ps1 Log-Temiz ile ayni desen)
  ! grep -Eqi 'temporal tiling|retrying with|ALLOC_FAILED|cannot make enough memory' "$1"
}
asama_kos() {   # asama_kos <etiket> <log> VAR=deger ...  -> sd-cli cikis kodunu dondurur; DUR ve sure tavani izlenir
  local etiket="$1" log="$2"; shift 2
  env "$@" "$SD_CLI" "${ARGS[@]}" > "$log" 2>&1 &
  local pid=$! t0=$SECONDS kod=0
  while kill -0 "$pid" 2>/dev/null; do
    if [[ -e "$DUR" ]]; then
      kill -TERM "$pid" 2>/dev/null || true; wait "$pid" 2>/dev/null || true
      echo "DURDU (DUR dosyasi) asama$etiket"; exit 2
    fi
    if (( SECONDS - t0 > TAVAN_DK * 60 )); then
      kill -TERM "$pid" 2>/dev/null || true; wait "$pid" 2>/dev/null || true
      hata VT-E-TAVAN "asama$etiket ${TAVAN_DK} dk'yi asti, kesildi (uzun kosu icin --tavan-dk arttirin)"
    fi
    sleep 2
  done
  wait "$pid" || kod=$?
  return "$kod"
}

echo "uret: $KARE kare, ${W}x${H}, $([[ "$IKI_ASAMA" -eq 1 ]] && echo 2 || echo 1) asama, cikti $OUT_AVI (DENEYSEL Linux yolu)"
[[ "$F32" -eq 1 ]] && echo "bilgi: compute capability $GPU_CC_YAZI >= 7.0: GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32 (uzun videoda siyah kare onlemi; kendiniz ayarlarsaniz dokunulmaz)"
[[ "$STANDART" -eq 1 ]] || echo "bilgi: ${W}x${H} standart disi boyut (olculen ve bayt kanitli tek boyut 640x384; kalite kapisi esikleri 640x384 icin kalibre)"
[[ "$TEK_ASAMA" -eq 1 && "$JETON" -gt 7680 ]] && echo "bilgi: --tek-asama: iki asama elle kapatildi; bu uzunlukta VAE bellege sigmayabilir (log karolu geri-dususu gosterirse cikti GECERSIZ sayilir)."

if [[ "$IKI_ASAMA" -eq 1 ]]; then
  echo "== Asama 1: DiT (latent uretimi)"
  k1=0; asama_kos _a1 "$LOG1" "${ENV1[@]}" || k1=$?
  if [[ ! -f "$LATENT" ]] || [[ "$(wc -c < "$LATENT")" -lt 1048576 ]]; then
    tail -n 25 "$LOG1" >&2 || true; vram_ipucu
    hata VT-E-LATENT "asama 1 latent yazmadi (cikis $k1); $LOG1 dosyasina bakin"
  fi
  echo "== Asama 2: VAE (video + ses cozme, ayri surec)"
  rm -f "$OUT_AVI"
  k2=0; asama_kos _a2 "$LOG2" "${ENV2[@]}" || k2=$?
  [[ "$k2" -eq 0 ]] || echo "UYARI: asama 2 cikis kodu '$k2' (tek basina basari olcutu degil; avi + kare sayisi + log denetlenir)"
  SON_LOG="$LOG2"
else
  echo "== Tek asama: DiT + VAE"
  k1=0; asama_kos _a1 "$LOG1" "${ENV1[@]}" || k1=$?
  [[ "$k1" -eq 0 ]] || echo "UYARI: sd-cli cikis kodu '$k1' (tek basina basari olcutu degil; avi + kare sayisi + log denetlenir)"
  SON_LOG="$LOG1"
fi

if ! log_temiz "$SON_LOG"; then
  vram_ipucu
  hata VT-E-TILING "logda karolu VAE geri-dususu ya da bellek hatasi: cikti GECERSIZ ($SON_LOG)"
fi
if [[ ! -f "$OUT_AVI" ]] || [[ "$(wc -c < "$OUT_AVI")" -lt 10240 ]]; then
  tail -n 30 "$SON_LOG" >&2 || true; vram_ipucu
  hata VT-E-CIKTI "cikti dosyasi yok ya da cok kucuk: $OUT_AVI (sd-cli cikis kodu: ${k2:-$k1})"
fi

# ffprobe varsa: kare sayisi ve ses akisi (uret.ps1 ile ayni; yoksa yalniz UYARI, kapidaki kare sayimi yine yapilir)
FFPROBE=""
for c in "$ENGINE_BIN/ffprobe" ffprobe; do if command -v "$c" >/dev/null 2>&1; then FFPROBE="$c"; break; fi; done
if [[ -n "$FFPROBE" ]]; then
  n="$("$FFPROBE" -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 "$OUT_AVI" 2>/dev/null | head -n1 | tr -dc '0-9' || true)"
  if [[ -n "$n" ]]; then
    [[ "$n" -eq "$KARE" ]] || hata VT-E-KARESAYISI "kare sayisi $n (ffprobe), beklenen $KARE: cikti GECERSIZ"
    echo "kare sayisi dogrulandi: $n (ffprobe)"
  fi
  turler="$("$FFPROBE" -v error -show_entries stream=codec_type -of csv=p=0 "$OUT_AVI" 2>/dev/null || true)"
  if [[ "$turler" == *video* ]]; then
    if [[ "$turler" == *audio* ]]; then echo "ses akisi var"; else hata VT-E-SES "ses akisi yok: cikti GECERSIZ (model ses uretir; log ve istemdeki audio: cumlesini kontrol edin)"; fi
  fi
else
  echo "UYARI: ffprobe yok; ses akisi dogrulanmadi (kare sayisi kalite kapisinda sayilir)"
fi

if [[ "$KONTROL" -eq 0 ]]; then
  # Kalite kapisi = uretim_kapi.ps1 ile ayni esikler: kare = beklenen VE gurultu <= 1,5 VE orta akis > 0,05. Esiklere dokunulmaz (docs/KAPILAR.md).
  echo "== Kalite kapisi (scripts/dikis_denetim.py)"
  kapi_cikti="$("$PY" -I "$SCRIPT_DIR/dikis_denetim.py" "$OUT_AVI" 2>&1)" && kapi_kod=0 || kapi_kod=$?
  if [[ "$kapi_kod" -eq 6 || "$kapi_kod" -eq 3 ]] || [[ "$kapi_cikti" =~ (No\ module\ named|ModuleNotFoundError|ImportError) ]]; then
    echo "VIDEO URETILDI ama KAPI CALISMADI [VT-E-PY] (python'da opencv/numpy yok ya da okunamadi): klip kabul edilmedi sayilir: $OUT_AVI" >&2
    echo "${kapi_cikti:0:300}" >&2
    exit 6
  fi
  if ! [[ "$kapi_cikti" =~ kare=([0-9]+)\ gurultu=([0-9.]+).*orta\ akis=([0-9.]+) ]]; then
    echo "KAPI RED: [VT-E-KAPI-RED] dikis_denetim cikti ayristirilamadi: ${kapi_cikti:0:200}" >&2
    exit 5
  fi
  olc="${BASH_REMATCH[1]}"; gur="${BASH_REMATCH[2]}"; ak="${BASH_REMATCH[3]}"
  if [[ "$olc" -eq "$KARE" ]] && buyuk_mu 1.5 "$gur" && buyuk_mu "$ak" 0.0500001; then
    echo "KAPI GECTI: kare=$olc gurultu=$gur orta_akis=$ak"
    dn="$("$PY" -I "$SCRIPT_DIR/doku_norm.py" "$OUT_AVI" 2>&1 | head -n 3 || true)"
    echo "DOKU_NORM (bilgi, kapi degil): ${dn:0:300}"
  else
    if [[ "$olc" -eq "$KARE" ]] && buyuk_mu "$ak" 0.0500001; then
      echo "BILGI: yalniz gurultu esigi asildi; dokulu sahne (kum, cim, dal) olabilir: docs/KAPILAR.md 3. Esik gevsetilmez."
    fi
    echo "KAPI RED: [VT-E-KAPI-RED] kare=$olc (beklenen $KARE) gurultu=$gur (<=1,5) orta_akis=$ak (>0,05); klip kabul edilmez, karar kullanicinindir; docs/KAPILAR.md" >&2
    exit 5
  fi
  [[ "$STANDART" -eq 1 ]] || echo "UYARI: kalite kapisi esikleri 640x384 icin kalibre; ${W}x${H} boyutunda gurultu/N degerleri karsilastirilamaz. Videoyu gozle izleyin (docs/KAPILAR.md)."
  echo "Kalite kapisi lisans uygunlugunu denetlemez; cikti kullanimi sizin sorumlulugunuzdadir: docs/LISANS_UYARISI.md"
  echo "This gate does not check motion consistency (object scale or position jumps): watch the whole video before accepting it."
fi

echo "TAMAM: $OUT_AVI"
