#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "tavus"

# Configure the client
client = Tavus::Client.new(api_key: ENV.fetch("TAVUS_API_KEY", "your-api-key-here"))

puts "=== Advanced Persona Configuration Example ===\n\n"

# Create a persona with advanced layer configurations
puts "Creating an advanced persona with custom layers..."

begin
  persona = client.personas.create(
    persona_name: "Customer Support Agent",
    system_prompt: "You are a helpful customer support agent for a SaaS company. " \
                   "You help customers with technical issues, billing questions, and general inquiries.",
    pipeline_mode: "full",
    context: "The company offers project management software with features including task tracking, " \
             "team collaboration, and reporting. Pricing plans range from $10-$50 per user per month.",
    layers: {
      # Language Model Configuration
      llm: {
        model: "tavus-gpt-4o",
        tools: [
          {
            type: "function",
            function: {
              name: "check_account_status",
              description: "Check the status of a customer's account including subscription and usage",
              parameters: {
                type: "object",
                properties: {
                  account_id: {
                    type: "string",
                    description: "The customer's account ID"
                  }
                },
                required: ["account_id"]
              }
            }
          },
          {
            type: "function",
            function: {
              name: "create_support_ticket",
              description: "Create a support ticket for issues that need follow-up",
              parameters: {
                type: "object",
                properties: {
                  title: {
                    type: "string",
                    description: "Brief description of the issue"
                  },
                  priority: {
                    type: "string",
                    enum: ["low", "medium", "high", "urgent"],
                    description: "Priority level of the ticket"
                  }
                },
                required: ["title", "priority"]
              }
            }
          }
        ]
      },

      # Text-to-Speech Configuration
      tts: {
        tts_engine: "cartesia",
        voice_settings: {
          speed: 1.0,
          emotion: ["positivity:high", "curiosity:medium"]
        },
        tts_emotion_control: "true",
        tts_model_name: "sonic"
      },

      # Speech-to-Text Configuration
      stt: {
        stt_engine: "tavus-turbo",
        participant_pause_sensitivity: "medium",
        participant_interrupt_sensitivity: "low",
        smart_turn_detection: true,
        hotwords: "SaaS, API, webhook, integration, dashboard"
      },

      # Perception Configuration
      perception: {
        perception_model: "raven-0",
        ambient_awareness_queries: [
          "Does the customer appear frustrated or confused?",
          "Is the customer showing their screen or pointing at something?"
        ]
      }
    }
  )

  puts "✓ Created advanced persona: #{persona['persona_id']}"
  persona_id = persona["persona_id"]

  # Demonstrate updating specific layers
  puts "\nUpdating TTS emotion settings..."
  
  operations = [
    {
      op: "replace",
      path: "/layers/tts/voice_settings/emotion",
      value: ["positivity:very-high", "enthusiasm:high"]
    },
    {
      op: "replace",
      path: "/layers/stt/participant_pause_sensitivity",
      value: "low"
    }
  ]

  client.personas.patch(persona_id, operations)
  puts "✓ Updated persona layers"

  # Get the updated persona details
  puts "\nRetrieving updated persona..."
  updated_persona = client.personas.get(persona_id)
  puts "✓ Persona configuration:"
  puts "  Name: #{updated_persona['data']&.first&.dig('persona_name')}"
  puts "  System Prompt: #{updated_persona['data']&.first&.dig('system_prompt')[0..80]}..."
  
  tts_settings = updated_persona.dig("data", 0, "layers", "tts")
  if tts_settings
    puts "  TTS Engine: #{tts_settings['tts_engine']}"
    puts "  Emotion Control: #{tts_settings['tts_emotion_control']}"
  end

  # Cleanup (optional)
  # puts "\nCleaning up..."
  # client.personas.delete(persona_id)
  # puts "✓ Deleted persona"

rescue Tavus::BadRequestError => e
  puts "✗ Bad request: #{e.message}"
rescue Tavus::ApiError => e
  puts "✗ API error: #{e.message}"
end

puts "\n=== Example Complete ==="

