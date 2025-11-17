"""
Download Vakyansh Sanskrit TTS model

This script downloads the Sanskrit TTS model from available sources.
"""
import urllib.request
import sys

# Try multiple URLs for the model
MODEL_URLS = [
    "https://storage.googleapis.com/vakyansh-open-models/synthesis/indic-tts-sanskrit/vakyansh-sanskrit-tts.pt",
    "https://github.com/AI4Bharat/Indic-TTS/releases/download/v1.0/sanskrit_tts.pt",
    "https://objectstore.e2enetworks.net/indic-tts-models/sanskrit/checkpoint.pt"
]

OUTPUT_FILE = "sanskrit_tts.pt"

def download_with_progress(url, output_file):
    """Download file with progress indicator"""
    print(f"Attempting download from: {url}")
    
    def progress_hook(block_num, block_size, total_size):
        downloaded = block_num * block_size
        if total_size > 0:
            percent = min(100, downloaded * 100 / total_size)
            sys.stdout.write(f"\rDownloading: {percent:.1f}% ({downloaded/1024/1024:.1f} MB)")
            sys.stdout.flush()
    
    try:
        urllib.request.urlretrieve(url, output_file, progress_hook)
        print(f"\n✓ Successfully downloaded to {output_file}")
        return True
    except Exception as e:
        print(f"\n✗ Failed: {e}")
        return False


def main():
    print("Sanskrit TTS Model Downloader")
    print("=" * 50)
    
    for url in MODEL_URLS:
        if download_with_progress(url, OUTPUT_FILE):
            print(f"\n✓ Model ready at: {OUTPUT_FILE}")
            return
    
    print("\n✗ All download attempts failed")
    print("\nPlease manually download the model from:")
    print("https://storage.googleapis.com/vakyansh-open-models/")
    print(f"Save it as: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
