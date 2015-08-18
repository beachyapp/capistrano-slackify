require 'multi_json'

module Slackify
  class Payload

    def initialize(context, status)
      @context = context
      @status = status
    end

    def self.build(context, status)
      new(context, status).build
    end

    def build
      "'payload=#{payload}'"
    end

    def payload
      MultiJson.dump({
        channel: fetch(:slack_channel),
        username: fetch(:slack_username),
        parse: fetch(:slack_parse),
        attachments: [
          {
            text: text,
            fallback: text,
            color: color,
            title: fetch(:stage)
          }
        ]
      })
    end

    def fetch(*args, &block)
      @context.fetch(*args, &block)
    end

    def text
      @text ||= case @status
      when :starting
        fetch(:slack_deploy_starting_text)
      when :success
        fetch(:slack_text)
      when :failed
        fetch(:slack_deploy_failed_text)
      end
    end

    def color
      case @status
      when :starting
        fetch(:slack_deploy_starting_color)
      when :success
        fetch(:slack_deploy_finished_color)
      when :failed
        fetch(:slack_deploy_failed_color)
      end
    end
  end
end
