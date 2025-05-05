# Rclone Sync Checker for Android & S3-Compatible Remotes

This shell script allows you to verify the synchronization between a local directory on an Android device and a remote storage (Cubbit or any S3-compatible service) using `rclone`.

It compares the list and size of files on both ends, and reports any that are missing or different on the remote.

---

## 📦 Features

- Counts files and calculates total size on both local and remote storage
- Compares file names and sizes
- Detects missing or altered files on the remote
- Saves a detailed report to a `.txt` file
- Designed for Termux on Android, compatible with any S3 backend configured in `rclone`

---

## ⚙️ Requirements

- [`rclone`](https://rclone.org/) installed and configured
- [Termux](https://f-droid.org/packages/com.termux/) (for Android)
- Remote configured via `rclone config` (Cubbit, Amazon S3, Wasabi, etc.)

---

## 📂 Usage

1. **Configure the script**:
   ```sh
   src="/path/to/local/files"
   dest="remote:bucket/path"

    Run the script: "sh sync_check.sh"

Check the output:

    File counts and sizes on both sides

    Warning if mismatches exist

    Missing/mismatched files saved in:

        ~/files_missing.txt

🧪 Tested With

    Cubbit (via S3-compatible backend)

    Amazon S3

    Wasabi

    Termux on Android 15

    rclone v1.65+

📌 Example Output

⏳ Scanning files...

📱 On Android:
  File count: 1024
  Used space: 1.87 GB

☁️ On remote (S3-compatible):
  File count: 1010
  Used space: 1.84 GB

⚠️ WARNING: File count does not match!
⚠️ WARNING: Storage usage does not match!

📋 Comparing local vs remote files (name and size)...

❌ Files present on Android but missing or different on remote: <br>
IMG_20240504_123456.jpg|2048000 <br>
VID_20240503_223011.mp4|10485760

📄 Report saved to: /data/data/com.termux/files/home/files_missing.txt

🤝 Contributing

Feel free to submit issues or pull requests.
📄 License

This project is licensed under the MIT License.
