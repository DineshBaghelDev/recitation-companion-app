"""
Application configuration module.

This module loads configuration from environment variables with sensible
defaults for development.
"""

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """
    Application settings loaded from environment variables.
    
    Attributes:
        vedic_api_base_url: Base URL for the Vedic Scriptures API
        host: Server host address
        port: Server port number
        reload: Enable auto-reload for development
        cors_origins: Comma-separated list of allowed CORS origins
    """
    
    # Vedic Scriptures API
    vedic_api_base_url: str = "https://vedicscriptures.github.io"
    
    # Server Configuration
    host: str = "0.0.0.0"
    port: int = 8000
    reload: bool = True
    
    # CORS Configuration
    cors_origins: str = "*"  # Allow all origins in development
    
    class Config:
        """Pydantic configuration."""
        env_file = ".env"
        case_sensitive = False


# Global settings instance
settings = Settings()
