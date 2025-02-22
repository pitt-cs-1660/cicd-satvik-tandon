# Builder stage
FROM python:3.11-buster AS builder

# Set working directory 
WORKDIR /app

# Install Poetry and upgrade pip
RUN pip install --upgrade pip && pip install poetry

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Configure Poetry to not create virtualenvs and install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi

# Copy application source code
COPY . .



# Final stage
FROM python:3.11-buster AS app

# Set working directory
WORKDIR /app

# Copy the installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy built application from builder stage
COPY --from=builder /app /app

# Expose port for FastAPI
EXPOSE 8000

# set entrypoint.sh as executible
RUN chmod +x entrypoint.sh

# Set the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]

# Command to start FastAPI
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]

