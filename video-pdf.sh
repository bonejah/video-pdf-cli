#!/bin/bash

set -e

# =========================
# DEPENDENCY CHECK
# =========================

install_dependencies() {
  echo ""
  echo "Installing missing dependencies..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
      echo "Homebrew not found. Please install Homebrew first:"
      echo "https://brew.sh/"
      exit 1
    fi

    brew install ffmpeg imagemagick yt-dlp

  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update
    sudo apt install -y ffmpeg imagemagick python3-pip
    pip3 install --upgrade yt-dlp

  else
    echo "Unsupported OS. Please install ffmpeg, imagemagick and yt-dlp manually."
    exit 1
  fi
}

check_dependency() {
  command -v "$1" &> /dev/null
}

MISSING=false
for cmd in ffmpeg magick yt-dlp; do
  if ! check_dependency "$cmd"; then
    MISSING=true
  fi
done

if [ "$MISSING" = true ]; then
  install_dependencies
fi

# =========================
# UI
# =========================

clear

echo "========================================"
echo "      VIDEO TO PDF GENERATOR (CLI)      "
echo "========================================"
echo ""

read -p "Enter the video URL: " VIDEO_URL
echo ""

read -p "Enter output PDF name (without .pdf): " PDF_NAME
echo ""

read -p "Enter output directory (full path): " OUTPUT_DIR
echo ""

echo ""
echo "Frames interval in seconds (default: 10)"
echo ""
echo "Examples (for ~10 minute video):"
echo "--------------------------------------"
echo "  10     → ~60 frames"
echo "  5      → ~120 frames"
echo "  1      → ~600 frames"
echo "  0.5    → ~1200 frames"
echo "--------------------------------------"
echo ""
echo "Smaller interval = more pages in the PDF"
echo ""
read -p "Interval: " INTERVAL
INTERVAL=${INTERVAL:-10}
echo ""

read -p "Resolution (default 1280x720): " RES_INPUT
RES_INPUT=${RES_INPUT:-1280x720}
RESOLUTION="${RES_INPUT/x/:}"
echo ""

read -p "Generate separate PDFs per frame? (y/N): " SEPARATE_INPUT
if [[ "$SEPARATE_INPUT" =~ ^[Yy]$ ]]; then
  SEPARATE=true
else
  SEPARATE=false
fi

echo ""
echo "========================================"
echo "Processing..."
echo "========================================"
echo ""

# =========================
# VALIDATION
# =========================

if [[ -z "$VIDEO_URL" || -z "$PDF_NAME" || -z "$OUTPUT_DIR" ]]; then
  echo "Error: URL, output name, and directory are required."
  exit 1
fi

if ! [[ "$INTERVAL" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Error: Interval must be a positive number (e.g. 0.5, 1, 5, 10)"
  exit 1
fi

# =========================
# WORKFLOW
# =========================

WORKDIR=$(mktemp -d)
cd "$WORKDIR"

echo "Downloading video..."
yt-dlp -f "best[height<=720]" -o video.mp4 "$VIDEO_URL"

if [[ ! -f video.mp4 ]]; then
  echo "Download failed."
  exit 1
fi

echo ""
echo "Extracting frames every $INTERVAL seconds..."

ffmpeg -hide_banner -loglevel error \
  -i video.mp4 \
  -vf "fps=1/$INTERVAL,scale=$RESOLUTION" \
  -q:v 2 frame_%04d.jpg

mkdir -p "$OUTPUT_DIR"

echo ""

if [ "$SEPARATE" = true ]; then
  echo "Generating separate PDFs..."
  k=0
  for img in frame_*.jpg; do
    ((k++))
    magick -density 150 "$img" "$OUTPUT_DIR/${PDF_NAME}_$k.pdf"
  done
  FINAL_PATH="$OUTPUT_DIR/"
else
  echo "Generating single PDF..."
  magick -density 150 frame_*.jpg "$OUTPUT_DIR/$PDF_NAME.pdf"
  FINAL_PATH="$OUTPUT_DIR/$PDF_NAME.pdf"
fi

echo ""
echo "Cleaning up..."
cd ..
rm -rf "$WORKDIR"

echo ""
echo "========================================"
echo "✅ DONE!"
echo "Saved at: $FINAL_PATH"
echo "========================================"