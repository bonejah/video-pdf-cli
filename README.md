# 🎬 Video to PDF CLI

Transform any online video (YouTube or direct URL) into a PDF made of
extracted frames.

This CLI tool downloads a video, extracts frames at a custom time
interval, and generates either:

-   📄 A single PDF containing all frames\
-   📑 Separate PDFs (one per frame)

------------------------------------------------------------------------

## 🚀 Features

-   Download videos from YouTube or other platforms
-   Extract frames at configurable intervals
-   Control output resolution
-   Generate single or multiple PDFs
-   Automatic dependency installation (macOS & Linux)
-   Clean temporary workspace handling

------------------------------------------------------------------------

## 📦 Dependencies

The script automatically installs (if missing):

-   ffmpeg
-   imagemagick
-   yt-dlp

### macOS

Uses Homebrew.

### Linux

Uses apt + pip.

------------------------------------------------------------------------

## 🛠 Installation

Clone the repository:

``` bash
git clone https://github.com/your-username/video-pdf-cli.git
cd video-pdf-cli
```

Make the script executable:

``` bash
chmod +x video-pdf.sh
```

Run it:

``` bash
./video-pdf.sh
```

------------------------------------------------------------------------

## 💻 Usage

When executed, the CLI will prompt:

    ========================================
          VIDEO TO PDF GENERATOR (CLI)
    ========================================

    Enter the video URL:
    Enter output PDF name (without .pdf):
    Enter output directory (full path):

    Frames interval in seconds (default: 10)

    Examples (for ~10 minute video):
    --------------------------------------
      10     → ~60 frames
      5      → ~120 frames
      1      → ~600 frames
      0.5    → ~1200 frames
    --------------------------------------

    Resolution (default 1280x720):
    Generate separate PDFs per frame? (y/N):

------------------------------------------------------------------------

## 📊 Understanding Frame Interval

The interval defines how often a frame is captured.

Formula used internally:

    fps = 1 / interval

### Examples

  Interval   Frames per Second   Approx. Frames (10min video)
  ---------- ------------------- ------------------------------
  10         0.1 fps             \~60
  5          0.2 fps             \~120
  1          1 fps               \~600
  0.5        2 fps               \~1200

⚠ Smaller interval = More frames = Larger PDF

------------------------------------------------------------------------

## 🧠 How It Works

1.  Downloads the video using yt-dlp
2.  Extracts frames using ffmpeg
3.  Converts images into PDF using ImageMagick
4.  Cleans temporary files automatically

------------------------------------------------------------------------

## 📁 Output

Single PDF:

/your/output/path/filename.pdf

Separate PDFs:

/your/output/path/filename_1.pdf\
/your/output/path/filename_2.pdf\
...

------------------------------------------------------------------------

## ⚡ Performance Tips

For long videos:

-   Use interval 5 or 10
-   Avoid 0.5 unless necessary
-   Keep resolution at 1280x720 or lower

Very small intervals can generate thousands of pages.

------------------------------------------------------------------------

## ❗ Notes

-   Works on macOS and Linux
-   Requires internet connection for video download
-   Temporary files are automatically removed after processing

------------------------------------------------------------------------

## 📄 License

MIT License

------------------------------------------------------------------------

## 👨‍💻 Author

Built as an open-source CLI project inspired by pdf-image-cli.
