import os
import requests

# 🔁 Folder with handwriting images
FOLDER_PATH = "/Users/anshuljagtap/Desktop/Handwriting Recognition App/backend/test_images"
URL = "http://127.0.0.1:8000/predict"

# 🔍 Loop through all image files
for filename in os.listdir(FOLDER_PATH):
    if filename.lower().endswith((".png", ".jpg", ".jpeg")):
        filepath = os.path.join(FOLDER_PATH, filename)
        print(f"\n🖼️ Testing {filename}...")

        with open(filepath, "rb") as f:
            files = {"file": f}
            try:
                response = requests.post(URL, files=files)
                if response.status_code == 200:
                    print("✅ Recognized Text:", response.json()["text"])
                else:
                    print("❌ Error:", response.status_code, response.text)
            except Exception as e:
                print("❌ Exception:", e)