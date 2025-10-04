# Tavus Ruby Client

[![Gem Version](https://badge.fury.io/rb/tavus.svg)](https://badge.fury.io/rb/tavus)

A Ruby gem for interacting with the [Tavus API](https://tavusapi.com), providing a simple and intuitive interface for managing Conversational Video Interfaces (CVI).

## Features

- **Conversations Management**: Create, retrieve, list, end, and delete real-time video conversations
- **Personas Management**: Create, retrieve, list, update, and delete AI personas with customizable behavior
- **Replicas Management**: Create, train, retrieve, list, rename, and delete AI replicas
- **Objectives Management**: Create, retrieve, list, update, and delete conversation objectives
- **Guardrails Management**: Create, retrieve, list, update, and delete behavioral guardrails
- **Knowledge Base (Documents)**: Upload, retrieve, list, update, and delete documents for personas
- **Video Generation**: Generate videos from text or audio, retrieve, list, rename, and delete videos
- **Full API Coverage**: Support for all Tavus API v2 endpoints
- **Easy Configuration**: Simple API key configuration
- **Comprehensive Error Handling**: Detailed error classes for different API responses
- **JSON Patch Support**: Update personas, objectives, and guardrails using JSON Patch operations (RFC 6902)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tavus'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install tavus
```

## Configuration

### Global Configuration

Configure the client globally (recommended for Rails applications):

```ruby
# config/initializers/tavus.rb
Tavus.configure do |config|
  config.api_key = ENV['TAVUS_API_KEY']
  config.base_url = 'https://tavusapi.com' # Optional, defaults to this
  config.timeout = 30 # Optional, defaults to 30 seconds
end
```

### Per-Instance Configuration

You can also configure individual client instances:

```ruby
client = Tavus::Client.new(
  api_key: 'your-api-key',
  base_url: 'https://tavusapi.com',
  timeout: 30
)
```

## Usage

For more comprehensive examples, check the [examples/](examples/) directory:
- [basic_usage.rb](examples/basic_usage.rb) - Basic operations with personas and conversations
- [advanced_persona.rb](examples/advanced_persona.rb) - Advanced persona configuration with custom layers
- [complete_workflow.rb](examples/complete_workflow.rb) - End-to-end workflow including replicas, documents, objectives, guardrails, and videos

### Conversations

#### Create a Conversation

```ruby
client = Tavus::Client.new(api_key: 'your-api-key')

# Create a conversation with required parameters
conversation = client.conversations.create(
  replica_id: 'rfe12d8b9597',
  persona_id: 'pdced222244b'
)

# Create a conversation with optional parameters
conversation = client.conversations.create(
  replica_id: 'rfe12d8b9597',
  persona_id: 'pdced222244b',
  conversation_name: 'Interview User',
  callback_url: 'https://yourwebsite.com/webhook',
  audio_only: false,
  conversational_context: 'I want to improve my sales techniques.',
  custom_greeting: 'Hey there!',
  memory_stores: ['anna'],
  document_ids: ['doc_1234567890'],
  document_retrieval_strategy: 'balanced',
  document_tags: ['sales', 'marketing'],
  test_mode: false
)

# Response includes:
# {
#   "conversation_id" => "c123456",
#   "conversation_name" => "Interview User",
#   "status" => "active",
#   "conversation_url" => "https://tavus.daily.co/c123456",
#   "replica_id" => "rfe12d8b9597",
#   "persona_id" => "pdced222244b",
#   "created_at" => "2025-10-04T12:00:00Z"
# }
```

#### Get a Conversation

```ruby
conversation = client.conversations.get('c123456')

# Response includes conversation details with status, URLs, etc.
```

#### List Conversations

```ruby
# List all conversations
conversations = client.conversations.list

# List with pagination and filters
conversations = client.conversations.list(
  limit: 20,
  page: 1,
  status: 'active' # or 'ended'
)

# Response includes:
# {
#   "data" => [...],
#   "total_count" => 123
# }
```

#### End a Conversation

```ruby
result = client.conversations.end('c123456')
```

#### Delete a Conversation

```ruby
result = client.conversations.delete('c123456')
```

### Personas

#### Create a Persona

```ruby
# Create a basic persona
persona = client.personas.create(
  system_prompt: 'As a Life Coach, you are a dedicated professional...',
  persona_name: 'Life Coach',
  pipeline_mode: 'full'
)

# Create a persona with advanced configuration
persona = client.personas.create(
  system_prompt: 'As a Life Coach...',
  persona_name: 'Life Coach',
  pipeline_mode: 'full',
  context: 'Here are a few times that you have helped...',
  default_replica_id: 'rfe12d8b9597',
  document_ids: ['d1234567890', 'd2468101214'],
  document_tags: ['product_info', 'company_policies'],
  layers: {
    llm: {
      model: 'tavus-gpt-4o',
      base_url: 'your-base-url',
      api_key: 'your-api-key',
      tools: [
        {
          type: 'function',
          function: {
            name: 'get_current_weather',
            description: 'Get the current weather in a given location',
            parameters: {
              type: 'object',
              properties: {
                location: {
                  type: 'string',
                  description: 'The city and state, e.g. San Francisco, CA'
                },
                unit: {
                  type: 'string',
                  enum: ['celsius', 'fahrenheit']
                }
              },
              required: ['location']
            }
          }
        }
      ]
    },
    tts: {
      tts_engine: 'cartesia',
      external_voice_id: 'external-voice-id',
      voice_settings: {
        speed: 0.5,
        emotion: ['positivity:high', 'curiosity']
      },
      tts_emotion_control: 'false',
      tts_model_name: 'sonic'
    },
    perception: {
      perception_model: 'raven-0',
      ambient_awareness_queries: [
        'Is the user showing an ID card?',
        'Does the user appear distressed or uncomfortable?'
      ]
    },
    stt: {
      stt_engine: 'tavus-turbo',
      participant_pause_sensitivity: 'low',
      participant_interrupt_sensitivity: 'low',
      hotwords: 'This is a hotword example',
      smart_turn_detection: true
    }
  }
)

# Response includes:
# {
#   "persona_id" => "p5317866",
#   "persona_name" => "Life Coach",
#   "created_at" => "2025-10-04T12:00:00Z"
# }
```

#### Get a Persona

```ruby
persona = client.personas.get('p5317866')
```

#### List Personas

```ruby
# List all personas
personas = client.personas.list

# List with pagination and filters
personas = client.personas.list(
  limit: 20,
  page: 1,
  persona_type: 'user' # or 'system'
)

# Response includes:
# {
#   "data" => [...],
#   "total_count" => 123
# }
```

#### Update a Persona (JSON Patch)

```ruby
# Update multiple fields using patch operations
operations = [
  { op: 'replace', path: '/persona_name', value: 'Wellness Advisor' },
  { op: 'replace', path: '/default_replica_id', value: 'r79e1c033f' },
  { op: 'replace', path: '/context', value: 'Updated context...' },
  { op: 'replace', path: '/layers/llm/model', value: 'tavus-gpt-4o' },
  { op: 'add', path: '/layers/tts/tts_emotion_control', value: 'true' },
  { op: 'remove', path: '/layers/stt/hotwords' }
]

result = client.personas.patch('p5317866', operations)

# Helper method to build patch operations
operation = client.personas.build_patch_operation(
  '/persona_name',
  'New Name',
  operation: 'replace'
)

# Convenient method to update a single field
result = client.personas.update_field(
  'p5317866',
  '/persona_name',
  'New Name'
)
```

#### Delete a Persona

```ruby
result = client.personas.delete('p5317866')
```

### Replicas

#### Create a Replica

```ruby
# Create a replica for conversational video
replica = client.replicas.create(
  train_video_url: 'https://my-bucket.s3.amazonaws.com/training-video.mp4',
  replica_name: 'My Replica',
  model_name: 'phoenix-3', # Optional, defaults to phoenix-3
  consent_video_url: 'https://my-bucket.s3.amazonaws.com/consent-video.mp4', # Optional
  callback_url: 'https://yourwebsite.com/webhook'
)

# Response includes:
# {
#   "replica_id" => "r783537ef5",
#   "status" => "started"
# }
```

#### Get a Replica

```ruby
# Get basic replica info
replica = client.replicas.get('r783537ef5')

# Get detailed replica info with verbose flag
replica = client.replicas.get('r783537ef5', verbose: true)
```

#### List Replicas

```ruby
# List all replicas
replicas = client.replicas.list

# List with filters
replicas = client.replicas.list(
  limit: 20,
  page: 1,
  replica_type: 'user', # or 'system'
  replica_ids: 're1074c227,r243eed46c',
  verbose: true
)
```

#### Rename a Replica

```ruby
client.replicas.rename('r783537ef5', 'Updated Replica Name')
```

#### Delete a Replica

```ruby
# Soft delete
client.replicas.delete('r783537ef5')

# Hard delete (irreversible - deletes all assets)
client.replicas.delete('r783537ef5', hard: true)
```

### Objectives

#### Create Objectives

```ruby
objectives = client.objectives.create(
  data: [
    {
      objective_name: 'Gather User Feedback',
      objective_prompt: 'Ask the user about their experience with the product',
      confirmation_mode: 'automatic',
      modality: 'verbal'
    }
  ]
)
```

#### Get an Objective

```ruby
objective = client.objectives.get('o12345')
```

#### List Objectives

```ruby
objectives = client.objectives.list(limit: 20, page: 1)
```

#### Update an Objective

```ruby
operations = [
  { op: 'replace', path: '/data/0/objective_name', value: 'Updated Objective' },
  { op: 'replace', path: '/data/0/confirmation_mode', value: 'manual' }
]

client.objectives.patch('o12345', operations)

# Or update a single field
client.objectives.update_field('o12345', '/data/0/objective_name', 'New Name')
```

#### Delete an Objective

```ruby
client.objectives.delete('o12345')
```

### Guardrails

#### Create Guardrails

```ruby
guardrails = client.guardrails.create(
  name: 'Healthcare Compliance Guardrails',
  data: [
    {
      guardrails_prompt: 'Never discuss competitor products or share sensitive medical information',
      modality: 'verbal',
      callback_url: 'https://your-server.com/webhook'
    }
  ]
)
```

#### Get Guardrails

```ruby
guardrails = client.guardrails.get('g12345')
```

#### List Guardrails

```ruby
guardrails = client.guardrails.list(limit: 20, page: 1)
```

#### Update Guardrails

```ruby
operations = [
  { op: 'replace', path: '/data/0/guardrails_prompt', value: 'Updated guardrails prompt' },
  { op: 'add', path: '/data/0/callback_url', value: 'https://new-server.com/webhook' }
]

client.guardrails.patch('g12345', operations)

# Or update a single field
client.guardrails.update_field('g12345', '/data/0/guardrails_prompt', 'New prompt')
```

#### Delete Guardrails

```ruby
client.guardrails.delete('g12345')
```

### Documents (Knowledge Base)

#### Create a Document

```ruby
# Upload from URL
document = client.documents.create(
  document_url: 'https://example.com/document.pdf',
  document_name: 'Product Documentation',
  callback_url: 'https://your-server.com/webhook',
  tags: ['product', 'documentation'],
  properties: { department: 'sales', priority: 'high' }
)

# Supported formats: .pdf, .txt, .docx, .doc, .png, .jpg, .pptx, .csv, .xlsx
# Also supports website URLs for snapshots
```

#### Get a Document

```ruby
document = client.documents.get('d290f1ee-6c54-4b01-90e6-d701748f0851')
```

#### List Documents

```ruby
# List all documents
documents = client.documents.list

# List with filters
documents = client.documents.list(
  limit: 20,
  page: 0,
  sort: 'descending',
  status: 'ready',
  tags: 'product,documentation'
)
```

#### Update a Document

```ruby
client.documents.update(
  'd290f1ee-6c54-4b01-90e6-d701748f0851',
  document_name: 'Updated Document Name',
  tags: ['updated', 'important']
)
```

#### Delete a Document

```ruby
client.documents.delete('d290f1ee-6c54-4b01-90e6-d701748f0851')
```

### Videos

#### Generate a Video

```ruby
# Generate video from text script
video = client.videos.create(
  replica_id: 'r783537ef5',
  script: 'Hello from Tavus! Enjoy your new replica',
  video_name: 'My First Video',
  background_url: 'https://yourwebsite.com/',
  callback_url: 'https://yourwebsite.com/webhook'
)

# Or use the convenient method
video = client.videos.generate_from_text(
  replica_id: 'r783537ef5',
  script: 'Hello from Tavus!',
  video_name: 'My Video'
)

# Generate video from audio file
video = client.videos.generate_from_audio(
  replica_id: 'r783537ef5',
  audio_url: 'https://my-bucket.s3.amazonaws.com/audio.mp3',
  video_name: 'Audio Video'
)

# Advanced options
video = client.videos.create(
  replica_id: 'r783537ef5',
  script: 'Hello!',
  fast: true, # Use fast rendering
  transparent_background: true, # Requires fast: true
  watermark_image_url: 'https://s3.amazonaws.com/watermark.png',
  background_source_url: 'https://my-bucket.s3.amazonaws.com/background.mp4'
)

# Response includes:
# {
#   "video_id" => "abcd123",
#   "status" => "queued",
#   "hosted_url" => "https://tavus.video/abcd123"
# }
```

#### Get a Video

```ruby
# Get basic video info
video = client.videos.get('abcd123')

# Get detailed info with thumbnails
video = client.videos.get('abcd123', verbose: true)

# Response includes download_url, stream_url, hosted_url when ready
```

#### List Videos

```ruby
videos = client.videos.list(limit: 20, page: 1)
```

#### Rename a Video

```ruby
client.videos.rename('abcd123', 'New Video Name')
```

#### Delete a Video

```ruby
# Soft delete
client.videos.delete('abcd123')

# Hard delete (irreversible - deletes all assets)
client.videos.delete('abcd123', hard: true)
```

## Error Handling

The gem provides specific error classes for different API responses:

```ruby
begin
  conversation = client.conversations.create(replica_id: 'invalid')
rescue Tavus::AuthenticationError => e
  # Handle authentication errors (401)
  puts "Authentication failed: #{e.message}"
rescue Tavus::BadRequestError => e
  # Handle bad request errors (400)
  puts "Bad request: #{e.message}"
rescue Tavus::NotFoundError => e
  # Handle not found errors (404)
  puts "Resource not found: #{e.message}"
rescue Tavus::ValidationError => e
  # Handle validation errors (422)
  puts "Validation failed: #{e.message}"
rescue Tavus::RateLimitError => e
  # Handle rate limit errors (429)
  puts "Rate limit exceeded: #{e.message}"
rescue Tavus::ServerError => e
  # Handle server errors (5xx)
  puts "Server error: #{e.message}"
rescue Tavus::ApiError => e
  # Handle any other API errors
  puts "API error: #{e.message}"
rescue Tavus::ConfigurationError => e
  # Handle configuration errors
  puts "Configuration error: #{e.message}"
end
```

## API Reference

### Conversations

| Method | Description |
|--------|-------------|
| `create(replica_id:, persona_id:, **options)` | Create a new conversation |
| `get(conversation_id)` | Get a conversation by ID |
| `list(**options)` | List all conversations |
| `end(conversation_id)` | End a conversation |
| `delete(conversation_id)` | Delete a conversation |

### Personas

| Method | Description |
|--------|-------------|
| `create(system_prompt:, **options)` | Create a new persona |
| `get(persona_id)` | Get a persona by ID |
| `list(**options)` | List all personas |
| `patch(persona_id, operations)` | Update a persona using JSON Patch |
| `build_patch_operation(field, value, operation:)` | Build a JSON Patch operation |
| `update_field(persona_id, field, value)` | Update a single field |
| `delete(persona_id)` | Delete a persona |

### Replicas

| Method | Description |
|--------|-------------|
| `create(train_video_url:, **options)` | Create a new replica |
| `get(replica_id, verbose: false)` | Get a replica by ID |
| `list(**options)` | List all replicas |
| `rename(replica_id, replica_name)` | Rename a replica |
| `delete(replica_id, hard: false)` | Delete a replica |

### Objectives

| Method | Description |
|--------|-------------|
| `create(data:)` | Create new objectives |
| `get(objectives_id)` | Get an objective by ID |
| `list(**options)` | List all objectives |
| `patch(objectives_id, operations)` | Update an objective using JSON Patch |
| `build_patch_operation(field, value, operation:)` | Build a JSON Patch operation |
| `update_field(objectives_id, field, value)` | Update a single field |
| `delete(objectives_id)` | Delete an objective |

### Guardrails

| Method | Description |
|--------|-------------|
| `create(name:, data:)` | Create new guardrails |
| `get(guardrails_id)` | Get guardrails by ID |
| `list(**options)` | List all guardrails |
| `patch(guardrails_id, operations)` | Update guardrails using JSON Patch |
| `build_patch_operation(field, value, operation:)` | Build a JSON Patch operation |
| `update_field(guardrails_id, field, value)` | Update a single field |
| `delete(guardrails_id)` | Delete guardrails |

### Documents (Knowledge Base)

| Method | Description |
|--------|-------------|
| `create(document_url:, **options)` | Upload a new document |
| `get(document_id)` | Get a document by ID |
| `list(**options)` | List all documents |
| `update(document_id, **options)` | Update document metadata |
| `delete(document_id)` | Delete a document |

### Videos

| Method | Description |
|--------|-------------|
| `create(replica_id:, **options)` | Generate a new video |
| `generate_from_text(replica_id:, script:, **options)` | Generate video from text |
| `generate_from_audio(replica_id:, audio_url:, **options)` | Generate video from audio |
| `get(video_id, verbose: false)` | Get a video by ID |
| `list(**options)` | List all videos |
| `rename(video_id, video_name)` | Rename a video |
| `delete(video_id, hard: false)` | Delete a video |

## JSON Patch Operations

Several resources (Personas, Objectives, and Guardrails) support updates via JSON Patch operations following [RFC 6902](https://tools.ietf.org/html/rfc6902). This allows for precise, atomic updates to specific fields.

### Supported Operations

- `add`: Add a new field or array element
- `remove`: Remove a field or array element
- `replace`: Replace an existing field value
- `copy`: Copy a value from one location to another
- `move`: Move a value from one location to another
- `test`: Test that a value at a location equals a specified value

### Examples

```ruby
# Replace a single field
operations = [
  { op: 'replace', path: '/persona_name', value: 'New Name' }
]

# Multiple operations in one request
operations = [
  { op: 'replace', path: '/persona_name', value: 'Updated Name' },
  { op: 'add', path: '/layers/tts/tts_emotion_control', value: 'true' },
  { op: 'remove', path: '/layers/stt/hotwords' }
]

# Update nested fields
operations = [
  { op: 'replace', path: '/layers/llm/model', value: 'tavus-gpt-4o' }
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## CI/CD

This project uses GitHub Actions for continuous integration:

- **Tests**: Runs on Ruby 2.7, 3.0, 3.1, 3.2, and 3.3
- **Linting**: RuboCop style checking
- **Security**: Bundle audit for dependency vulnerabilities

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vbrazo/tavus.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Resources

- [Tavus API Documentation](https://docs.tavus.io)
- [Tavus Developer Portal](https://platform.tavus.io)
- [GitHub Repository](https://github.com/vbrazo/tavus)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and version history.
