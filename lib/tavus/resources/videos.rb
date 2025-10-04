# frozen_string_literal: true

module Tavus
  module Resources
    class Videos
      def initialize(client)
        @client = client
      end

      # Generate a new video
      # @param replica_id [String] Unique identifier for the replica (required)
      # @param options [Hash] Additional parameters
      # @option options [String] :script Text script for video generation (required if no audio_url)
      # @option options [String] :audio_url URL to audio file (required if no script)
      # @option options [String] :video_name Name for the video
      # @option options [String] :background_url Link to website for background
      # @option options [String] :background_source_url Direct link to background video
      # @option options [String] :callback_url URL to receive callbacks
      # @option options [Boolean] :fast Use fast rendering process (default: false)
      # @option options [Boolean] :transparent_background Generate with transparent background (requires fast: true)
      # @option options [String] :watermark_image_url URL to watermark image
      # @option options [Hash] :properties Additional properties
      # @return [Hash] The created video details
      def create(replica_id:, **options)
        body = options.merge(replica_id: replica_id)

        # Validate that either script or audio_url is provided
        unless body[:script] || body[:audio_url]
          raise ArgumentError, "Either :script or :audio_url must be provided"
        end

        @client.post("/v2/videos", body: body)
      end

      # Convenient method to generate video from text
      # @param replica_id [String] Unique identifier for the replica
      # @param script [String] Text script for video generation
      # @param options [Hash] Additional parameters
      # @return [Hash] The created video details
      def generate_from_text(replica_id:, script:, **options)
        create(replica_id: replica_id, script: script, **options)
      end

      # Convenient method to generate video from audio
      # @param replica_id [String] Unique identifier for the replica
      # @param audio_url [String] URL to audio file
      # @param options [Hash] Additional parameters
      # @return [Hash] The created video details
      def generate_from_audio(replica_id:, audio_url:, **options)
        create(replica_id: replica_id, audio_url: audio_url, **options)
      end

      # Get a single video by ID
      # @param video_id [String] The unique identifier of the video
      # @param verbose [Boolean] Include additional video data like thumbnails (default: false)
      # @return [Hash] The video details
      def get(video_id, verbose: false)
        params = verbose ? { verbose: true } : {}
        @client.get("/v2/videos/#{video_id}", params: params)
      end

      # List all videos
      # @param options [Hash] Query parameters
      # @option options [Integer] :limit Number of videos to return per page (default: 10)
      # @option options [Integer] :page Page number to return (default: 1)
      # @return [Hash] List of videos and total count
      def list(**options)
        @client.get("/v2/videos", params: options)
      end

      # Delete a video
      # @param video_id [String] The unique identifier of the video
      # @param hard [Boolean] If true, hard delete video and assets (irreversible)
      # @return [Hash] Success response
      def delete(video_id, hard: false)
        params = hard ? { hard: true } : {}
        @client.delete("/v2/videos/#{video_id}", params: params)
      end

      # Rename a video
      # @param video_id [String] The unique identifier of the video
      # @param video_name [String] New name for the video
      # @return [Hash] Success response
      def rename(video_id, video_name)
        @client.patch("/v2/videos/#{video_id}/name", body: { video_name: video_name })
      end
    end
  end
end

