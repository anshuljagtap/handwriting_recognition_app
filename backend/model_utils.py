# backend/model_utils.py
from transformers import TrOCRProcessor, VisionEncoderDecoderModel
from PIL import Image
from PIL import ImageOps, ImageEnhance

# Load model and processor globally
processor = TrOCRProcessor.from_pretrained("microsoft/trocr-large-handwritten")
model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-handwritten")

def preprocess_image(image: Image.Image) -> Image.Image:
    image = image.convert("L")  # Grayscale
    image = ImageOps.invert(image)  # Text becomes black on white
    image = ImageOps.autocontrast(image)  # Normalize brightness/contrast
    image = ImageEnhance.Sharpness(image).enhance(2.0)  # Make edges sharper
    image = image.convert("RGB")  # Convert back to RGB for TrOCR
    return image

def recognize_handwriting(image: Image.Image) -> str:
    image = preprocess_image(image) 
    pixel_values = processor(images=image, return_tensors="pt").pixel_values
    generated_ids = model.generate(pixel_values)
    generated_text = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
    return generated_text

