"""
Recitation Companion API - Main Application Module

This is the main FastAPI application that serves:
- Vedic scripture verses with translations
- Sanskrit Text-to-Speech synthesis
- Progress tracking and user data

For API documentation, visit /docs when the server is running.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .routers import verses, tts

# Create FastAPI application instance
app = FastAPI(
    title="Recitation Companion API",
    description=(
        "Backend API for the Recitation Companion App. "
        "Provides Vedic scripture verses, translations, and "
        "high-quality Sanskrit text-to-speech synthesis using "
        "the Vakyansh model."
    ),
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    contact={
        "name": "Recitation Companion",
        "url": "https://github.com/yourusername/recitation-companion",
    },
    license_info={
        "name": "MIT",
    }
)

# Configure CORS middleware
# Allow all localhost origins for development (Flutter web uses random ports)
cors_origins = settings.cors_origins.split(",") if settings.cors_origins != "*" else ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for development
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
    expose_headers=["*"],
)

# Include API routers
app.include_router(verses.router)
app.include_router(tts.router)


@app.get("/", tags=["health"])
async def root() -> dict:
    """
    Root endpoint providing API information.
    
    Returns:
        dict: API status and documentation links.
    """
    return {
        "status": "healthy",
        "message": "Recitation Companion API",
        "version": "1.0.0",
        "documentation": {
            "interactive": "/docs",
            "alternative": "/redoc"
        },
        "endpoints": {
            "verses": "/api/v1/verses",
            "tts": "/api/v1/tts",
            "health": "/health"
        }
    }


@app.get("/health", tags=["health"])
async def health_check() -> dict:
    """
    Health check endpoint for monitoring.
    
    Returns:
        dict: Service health status.
    """
    return {
        "status": "healthy",
        "service": "recitation-companion-api",
        "version": "1.0.0"
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.reload
    )



if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.reload
    )
