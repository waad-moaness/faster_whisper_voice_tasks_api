
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.11

# 1. Install system dependencies (root user)
RUN apt-get update \
 && apt-get install -y ffmpeg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 2. Create a non-root user (Hugging Face mandatory requirement)

RUN useradd -m -u 1000 user
USER user

# 3. Set environment variables
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH \
    PYTHONPATH=/home/user/app \
    WEB_CONCURRENCY=1 \
    PORT=7860

# 4. Set working directory
WORKDIR $HOME/app

# 5. Copy and install requirements
COPY --chown=user requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# 6. Copy the CONTENTS of your app folder into the current WORKDIR
COPY --chown=user ./app .

# 7. Expose the mandatory Hugging Face port
EXPOSE 7860

# 8. Start the FastAPI app with Gunicorn and Uvicorn workers
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:7860", "--workers", "1", "main:app"]