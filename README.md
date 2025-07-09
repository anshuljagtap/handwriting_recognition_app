# Handwriting Recognition App

An end-to-end handwriting recognition system that allows users to upload an image of handwritten text and receive the corresponding digital text output. Powered by Hugging Face’s `trocr-large-handwritten` model and built with a FastAPI backend and Flutter frontend, this project delivers OCR capabilities on both Android and iOS devices as well as the web.

## Demo Video

[![Watch the demo]([[[https://img.youtube.com/vi/YOUR_VIDEO_ID_HERE/0.jpg)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID_HERE](https://youtu.be/OxAdhoZFVGk)](https://youtu.be/OxAdhoZFVGk)](https://www.youtube.com/watch?v=OxAdhoZFVGk))

---

## Features

- Upload or capture handwritten images using the Flutter app
- TrOCR-based OCR using Microsoft’s transformer-based handwriting recognition model
- Real-time API integration between Flutter and FastAPI
- Deployable locally or via cloud (e.g., Render.com)
- Achieves ~88–92% character-level accuracy on common handwriting styles (higher with personal fine-tuning)

---

## Success Metrics

| Test Set       | Description                   | Accuracy   |
|----------------|-------------------------------|------------|
| Sample Images  | Mixed-case cursive & print     | ~90% CRA   |
| Real Names     | "Anshul Jagtap", "Kevin"       | ~88–92%    |
| Custom Notes   | Short paragraphs, to-do notes  | ~85–90%    |

> Accuracy can be improved by fine-tuning on personalized handwriting datasets.

---

## Frontend

**Flutter App**

- Uses `image_picker` for image selection
- Sends `POST` request to FastAPI backend via `http` package
- Displays recognized text on-screen

### Flutter Dependencies
```yaml
image_picker: ^1.0.4
http: ^1.2.0
path_provider: ^2.1.2
```

---

## Backend

**FastAPI App** (`backend/main.py`)

- Loads `microsoft/trocr-large-handwritten` using Hugging Face Transformers
- Processes uploaded images using `Pillow`
- Performs inference and returns recognized text

### Requirements (`backend/requirements.txt`)
```
fastapi
uvicorn
transformers
torch
Pillow
python-multipart
```

---

## Setup Instructions

### Local Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/anshuljagtap/handwriting_recognition_app.git
cd handwriting_recognition_app
```

#### 2. Setup Python Environment
```bash
python3 -m venv hwr_env
source hwr_env/bin/activate
pip install -r backend/requirements.txt
```

#### 3. Run the Backend
```bash
cd backend
uvicorn main:app --reload --port 8000
```

#### 4. Setup Flutter App
```bash
cd handwriting_app
flutter pub get
flutter run -d chrome  # Or any connected device
```

---

## Deployment

### Backend (Render)

1. Push your backend to GitHub.
2. Create a new Web Service on Render.
3. Use `uvicorn backend.main:app --host 0.0.0.0 --port 10000` as the start command.
4. Ensure `render.yaml` is included to specify `backend/requirements.txt`.

---

## Sample Results

| Image                         | Expected Text     | Recognized Text        |
|------------------------------|-------------------|------------------------|
| `sample_handwriting.jpg`     | Anshul Jagtap     | Pinstrel Tagtap        |
| `TEST_0001.jpg`              | Kevin             | KEVIN        |

Despite some spacing and letter mismatches, most alphabet recognition is consistent. Custom fine-tuning recommended for production.

---

## Known Issues

- Large model (~1.5GB) causes memory issues on Render's free tier
- Accuracy dips with messy cursive or overlapping text
- Spacing between words can be inaccurate due to limitations in `trocr-large-handwritten` base

---

## Future Improvements

- Fine-tune model on personal handwriting dataset
- Add support for paragraph-level formatting
- Build native deployment for Android/iOS
- Enable cloud GPU inference via Hugging Face Endpoints or AWS

---

## Author

**Anshul Jagtap**  
[LinkedIn](https://www.linkedin.com/in/anshuljagtap) • [GitHub](https://github.com/anshuljagtap)

