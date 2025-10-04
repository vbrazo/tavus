#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "tavus"

# Configure the client
Tavus.configure do |config|
  config.api_key = ENV.fetch("TAVUS_API_KEY", "your-api-key-here")
end

# Or create a client instance directly
client = Tavus::Client.new(api_key: ENV.fetch("TAVUS_API_KEY", "your-api-key-here"))

puts "=== Tavus Ruby Client Examples ===\n\n"

# Example 1: Create a Persona
puts "1. Creating a persona..."
begin
  persona = client.personas.create(
    system_prompt: "You are a friendly sales coach who helps people improve their sales techniques.",
    persona_name: "Sales Coach",
    pipeline_mode: "full",
    context: "You have 10 years of experience in B2B sales."
  )
  puts "✓ Created persona: #{persona['persona_id']}"
  persona_id = persona["persona_id"]
rescue Tavus::ApiError => e
  puts "✗ Error creating persona: #{e.message}"
  exit 1
end

# Example 2: List Personas
puts "\n2. Listing personas..."
begin
  personas = client.personas.list(limit: 10)
  puts "✓ Found #{personas['total_count']} personas"
  personas["data"]&.each do |p|
    puts "  - #{p['persona_name']} (#{p['persona_id']})"
  end
rescue Tavus::ApiError => e
  puts "✗ Error listing personas: #{e.message}"
end

# Example 3: Create a Conversation
puts "\n3. Creating a conversation..."
begin
  conversation = client.conversations.create(
    replica_id: "rfe12d8b9597", # Replace with your replica ID
    persona_id: persona_id,
    conversation_name: "Sales Training Session",
    test_mode: true # Set to false for actual conversation
  )
  puts "✓ Created conversation: #{conversation['conversation_id']}"
  puts "  URL: #{conversation['conversation_url']}"
  conversation_id = conversation["conversation_id"]
rescue Tavus::BadRequestError => e
  puts "✗ Error creating conversation: #{e.message}"
  puts "  Note: Make sure to use a valid replica_id"
end

# Example 4: List Conversations
puts "\n4. Listing conversations..."
begin
  conversations = client.conversations.list(status: "active")
  puts "✓ Found #{conversations['total_count']} active conversations"
rescue Tavus::ApiError => e
  puts "✗ Error listing conversations: #{e.message}"
end

# Example 5: Update Persona
puts "\n5. Updating persona..."
begin
  result = client.personas.update_field(
    persona_id,
    "/persona_name",
    "Expert Sales Coach"
  )
  puts "✓ Updated persona name"
rescue Tavus::ApiError => e
  puts "✗ Error updating persona: #{e.message}"
end

# Example 6: Get Persona Details
puts "\n6. Getting persona details..."
begin
  persona_details = client.personas.get(persona_id)
  puts "✓ Retrieved persona details"
  puts "  Name: #{persona_details['data']&.first&.dig('persona_name')}"
rescue Tavus::NotFoundError => e
  puts "✗ Persona not found: #{e.message}"
rescue Tavus::ApiError => e
  puts "✗ Error getting persona: #{e.message}"
end

# Cleanup (optional)
puts "\n7. Cleaning up (optional)..."
# Uncomment to delete the created persona
# begin
#   client.personas.delete(persona_id)
#   puts "✓ Deleted persona"
# rescue Tavus::ApiError => e
#   puts "✗ Error deleting persona: #{e.message}"
# end

puts "\n=== Examples Complete ==="

