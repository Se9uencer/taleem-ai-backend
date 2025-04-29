from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from transformers import pipeline
import tempfile

app = FastAPI()

# Allow CORS (important)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/transcribe")
async def transcribe(file: UploadFile = File(...)):
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".webm") as tmp:
            tmp.write(await file.read())
            tmp_path = tmp.name

        # Load model **inside** request instead of at startup
        model = pipeline("automatic-speech-recognition", model="tarteel-ai/whisper-base-ar-quran")

        result = model(tmp_path)

        return {
            "transcription": result["text"]
        }
    except Exception as e:
        print(e)
        return {"error": str(e)}
