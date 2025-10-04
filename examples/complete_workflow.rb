#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "tavus"

# Configure the client
client = Tavus::Client.new(api_key: ENV.fetch("TAVUS_API_KEY", "your-api-key-here"))

puts "=== Complete Tavus Workflow Example ===\n\n"

# Step 1: Create a Replica
puts "1. Creating a replica..."
begin
  replica = client.replicas.create(
    train_video_url: "https://your-bucket.s3.amazonaws.com/training-video.mp4",
    replica_name: "Sales Demo Replica",
    model_name: "phoenix-3"
  )
  puts "✓ Created replica: #{replica['replica_id']}"
  replica_id = replica["replica_id"]
rescue Tavus::BadRequestError => e
  puts "✗ Error creating replica: #{e.message}"
  puts "  Note: Using placeholder replica_id for demo"
  replica_id = "rfe12d8b9597"
end

# Step 2: Upload documents to Knowledge Base
puts "\n2. Uploading documents to knowledge base..."
begin
  document = client.documents.create(
    document_url: "https://example.com/product-guide.pdf",
    document_name: "Product Guide",
    tags: ["product", "sales"],
    properties: { category: "documentation" }
  )
  puts "✓ Uploaded document: #{document['uuid']}"
  document_id = document["uuid"]
rescue Tavus::ApiError => e
  puts "✗ Error uploading document: #{e.message}"
end

# Step 3: Create Objectives
puts "\n3. Creating conversation objectives..."
begin
  objectives = client.objectives.create(
    data: [
      {
        objective_name: "Qualify Lead",
        objective_prompt: "Determine if the prospect has budget and authority",
        confirmation_mode: "automatic",
        modality: "verbal"
      }
    ]
  )
  puts "✓ Created objectives: #{objectives['objectives_id']}"
  objectives_id = objectives["objectives_id"]
rescue Tavus::ApiError => e
  puts "✗ Error creating objectives: #{e.message}"
end

# Step 4: Create Guardrails
puts "\n4. Creating guardrails..."
begin
  guardrails = client.guardrails.create(
    name: "Sales Compliance Guardrails",
    data: [
      {
        guardrails_prompt: "Never make unrealistic promises or discuss competitor pricing",
        modality: "verbal"
      }
    ]
  )
  puts "✓ Created guardrails: #{guardrails['guardrails_id']}"
  guardrails_id = guardrails["guardrails_id"]
rescue Tavus::ApiError => e
  puts "✗ Error creating guardrails: #{e.message}"
end

# Step 5: Create a Persona
puts "\n5. Creating a persona..."
begin
  persona = client.personas.create(
    persona_name: "Sales Expert",
    system_prompt: "You are an expert sales representative who helps qualify leads and answer product questions.",
    pipeline_mode: "full",
    context: "You work for a SaaS company selling project management software.",
    default_replica_id: replica_id,
    document_ids: document_id ? [document_id] : [],
    layers: {
      tts: {
        tts_engine: "cartesia",
        voice_settings: {
          speed: 1.0,
          emotion: ["positivity:high", "professionalism:high"]
        }
      }
    }
  )
  puts "✓ Created persona: #{persona['persona_id']}"
  persona_id = persona["persona_id"]
rescue Tavus::ApiError => e
  puts "✗ Error creating persona: #{e.message}"
  exit 1
end

# Step 6: Create a Conversation
puts "\n6. Creating a conversation..."
begin
  conversation = client.conversations.create(
    replica_id: replica_id,
    persona_id: persona_id,
    conversation_name: "Sales Demo Call",
    test_mode: true
  )
  puts "✓ Created conversation: #{conversation['conversation_id']}"
  puts "  URL: #{conversation['conversation_url']}"
  conversation_id = conversation["conversation_id"]
rescue Tavus::ApiError => e
  puts "✗ Error creating conversation: #{e.message}"
end

# Step 7: Generate a Video
puts "\n7. Generating a video..."
begin
  video = client.videos.generate_from_text(
    replica_id: replica_id,
    script: "Hello! I'm excited to show you how our platform can help your team collaborate better.",
    video_name: "Sales Demo Video",
    fast: true
  )
  puts "✓ Created video: #{video['video_id']}"
  puts "  Status: #{video['status']}"
  puts "  Hosted URL: #{video['hosted_url']}"
  video_id = video["video_id"]
rescue Tavus::ApiError => e
  puts "✗ Error generating video: #{e.message}"
end

# Step 8: Check status and list resources
puts "\n8. Checking created resources..."
begin
  # List replicas
  replicas = client.replicas.list(limit: 5)
  puts "✓ Total replicas: #{replicas['total_count']}"

  # List personas
  personas = client.personas.list(limit: 5)
  puts "✓ Total personas: #{personas['total_count']}"

  # List conversations
  conversations = client.conversations.list(limit: 5)
  puts "✓ Total conversations: #{conversations['total_count']}"

  # List videos
  videos = client.videos.list(limit: 5)
  puts "✓ Total videos: #{videos['total_count']}"
rescue Tavus::ApiError => e
  puts "✗ Error listing resources: #{e.message}"
end

# Step 9: Update resources
puts "\n9. Updating resources..."
begin
  if persona_id
    client.personas.update_field(
      persona_id,
      "/persona_name",
      "Expert Sales Agent"
    )
    puts "✓ Updated persona name"
  end

  if video_id
    client.videos.rename(video_id, "Updated Sales Demo")
    puts "✓ Updated video name"
  end
rescue Tavus::ApiError => e
  puts "✗ Error updating resources: #{e.message}"
end

# Optional cleanup
puts "\n10. Cleanup (commented out - uncomment to enable)..."
# client.conversations.delete(conversation_id) if conversation_id
# client.videos.delete(video_id) if video_id
# client.personas.delete(persona_id) if persona_id
# client.guardrails.delete(guardrails_id) if guardrails_id
# client.objectives.delete(objectives_id) if objectives_id
# client.documents.delete(document_id) if document_id
# puts "✓ Cleaned up all resources"

puts "\n=== Workflow Complete ==="
puts "\nThis example demonstrated:"
puts "  • Creating and managing replicas"
puts "  • Uploading documents to knowledge base"
puts "  • Setting up objectives and guardrails"
puts "  • Creating personas with custom configurations"
puts "  • Starting conversations"
puts "  • Generating videos"
puts "  • Listing and updating resources"
