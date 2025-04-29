# Use official lightweight Python image
FROM python:3.10-slim

# Set work directory
WORKDIR /app

# Install OS dependencies
RUN apt-get update && apt-get install -y ffmpeg

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .

# Command to run the app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
