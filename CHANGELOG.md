# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-04

### Added

- Initial release of Tavus Ruby client
- Full coverage of Tavus API v2 endpoints

- **Conversations Management**:
  - Create conversation with replica and persona
  - Get conversation details by ID
  - List conversations with pagination and filtering
  - End active conversations
  - Delete conversations
  - Support for audio-only mode, custom greetings, conversational context
  - Document integration with IDs, tags, and retrieval strategies
  - Memory stores and callback webhooks

- **Personas Management**:
  - Create personas with system prompts and pipeline modes
  - Get persona details by ID
  - List personas with pagination and filtering
  - Update personas using JSON Patch operations (RFC 6902)
  - Delete personas
  - Helper methods for building patch operations and updating single fields
  - Full support for perception, STT, LLM, and TTS layer configuration
  - Custom tool/function integration support

- **Replicas Management**:
  - Create replicas from training videos
  - Get replica details with optional verbose mode
  - List replicas with pagination and filtering
  - Rename replicas
  - Delete replicas (soft and hard delete)
  - Support for consent videos and custom model selection

- **Objectives Management**:
  - Create conversation objectives
  - Get objective details by ID
  - List objectives with pagination
  - Update objectives using JSON Patch operations
  - Delete objectives
  - Helper methods for patch operations

- **Guardrails Management**:
  - Create guardrails for behavioral control
  - Get guardrails details by ID
  - List guardrails with pagination
  - Update guardrails using JSON Patch operations
  - Delete guardrails
  - Callback webhook support

- **Knowledge Base (Documents)**:
  - Upload documents from URLs
  - Get document details by ID
  - List documents with pagination, sorting, and filtering
  - Update document metadata (name and tags)
  - Delete documents
  - Support for multiple file formats (.pdf, .txt, .docx, .doc, .png, .jpg, .pptx, .csv, .xlsx)
  - Website snapshot support
  - Tag-based organization and search

- **Video Generation**:
  - Generate videos from text scripts
  - Generate videos from audio files
  - Get video details with optional verbose mode
  - List videos with pagination
  - Rename videos
  - Delete videos (soft and hard delete)
  - Advanced options: fast rendering, transparent backgrounds, custom backgrounds, watermarks

- **Configuration**:
  - Global configuration via `Tavus.configure`
  - Per-instance configuration
  - Configurable API key, base URL, and timeout

- **Error Handling**:
  - Comprehensive error classes for different HTTP status codes
  - `AuthenticationError` (401)
  - `BadRequestError` (400)
  - `NotFoundError` (404)
  - `ValidationError` (422)
  - `RateLimitError` (429)
  - `ServerError` (5xx)
  - `ApiError` (generic API errors)
  - `ConfigurationError` (configuration issues)

- **Documentation**:
  - Complete README with usage examples
  - API reference tables
  - Error handling guide
  - Configuration examples
  - Code examples for all endpoints
