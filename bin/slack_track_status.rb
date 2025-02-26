#!/usr/bin/env ruby
# frozen_string_literal: true

require 'slack-ruby-client'
require 'active_support/all'
require 'time'

# Set up Slack API token (Use environment variables for security)
SLACK_API_TOKEN = ENV['SLACK_API_TOKEN'] || 'your-slack-token-here'

Time.zone = 'Europe/Oslo' # ✅ Set default time zone

# Configure Slack Client
Slack.configure do |config|
  config.token = SLACK_API_TOKEN
end

client = Slack::Web::Client.new
$previous_status = nil
$previous_status_time = nil
$status_durations = Hash.new(0) # ✅ Global variable to track time spent in each status

# ✅ Uses users_getPresence to fetch live presence data
def get_user_status(client, user_id)
  response = client.users_getPresence(user: user_id)
  response['presence']
rescue Slack::Web::Api::Errors::SlackError => e
  puts "Error fetching user presence: #{e.message}"
  nil
end

def log_status(client, user_id)
  puts "Tracking Slack status for user: #{user_id}... Press Ctrl+C to stop."

  # Get initial status
  initial_status = get_user_status(client, user_id)
  if initial_status
    puts "[#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}] Initial status: #{initial_status.upcase}"
    $previous_status = initial_status
    $previous_status_time = Time.zone.now
  else
    puts 'Could not retrieve initial status.'
    return
  end

  loop do
    current_status = get_user_status(client, user_id)

    if current_status && current_status != $previous_status
      duration = Time.zone.now - $previous_status_time
      formatted_duration = format_duration(duration)

      puts "[#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}] User changed status to #{current_status.upcase} (Previous: #{$previous_status.upcase} for #{formatted_duration})"

      # ✅ Store time spent in previous status
      $status_durations[$previous_status] += duration

      # Update previous status and time
      $previous_status = current_status
      $previous_status_time = Time.zone.now
    end

    $stdout.flush
    sleep 10 # ✅ Polling interval set to 10 seconds
  end
rescue Interrupt
  # ✅ When script is stopped, store final duration
  if $previous_status
    final_duration = Time.zone.now - $previous_status_time
    $status_durations[$previous_status] += final_duration
  end

  puts "\nSummary of time spent in each status:"
  $status_durations.each do |status, time_spent|
    puts "- #{status.upcase}: #{format_duration(time_spent)}"
  end

  puts "\nStopped tracking."
  $stdout.flush
end

# ✅ Formats duration into readable time (e.g., "2h 30m 15s")
def format_duration(seconds)
  total_seconds = seconds.to_i
  hours = total_seconds / 3600
  minutes = (total_seconds % 3600) / 60
  secs = total_seconds % 60

  parts = []
  parts << "#{hours}h" if hours.positive?
  parts << "#{minutes}m" if minutes.positive?
  parts << "#{secs}s" if secs.positive?
  parts.join(' ')
end

# ✅ List all active users if no user ID is provided
def list_users(client)
  puts "Fetching active users...\n"
  users = client.users_list

  users['members'].each do |user|
    next if user['deleted'] # ✅ Skip disabled users

    puts "#{user['real_name']} (@#{user['name']}) - ID: #{user['id']}"
  end
rescue Slack::Web::Api::Errors::SlackError => e
  puts "Error fetching users: #{e.message}"
end

# ✅ MAIN SCRIPT LOGIC
if ARGV.empty?
  list_users(client) # ✅ List all active users if no ID is provided
  exit
else
  user_id = ARGV[0]
  log_status(client, user_id)
end
