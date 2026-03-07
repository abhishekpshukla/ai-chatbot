# frozen_string_literal: true

class ChatsController < ApplicationController
  def index
    @business = Business.first
  end

  def create
    business = Business.find(params[:business_id])
    conversation = business.conversations.find_or_create_by!(session_id: session.id.to_s)
    reply = ChatService.new(conversation: conversation, user_message: params[:message].to_s).call
    render json: { reply: reply }
  rescue ActiveRecord::RecordNotFound => e
    render json: { reply: "", error: "Business not found." }, status: :not_found
  rescue StandardError => e
    Rails.logger.error("[ChatsController#create] #{e.class}: #{e.message}\n#{e.backtrace.first(5).join("\n")}")
    render json: { reply: "", error: "Something went wrong. Please try again." }, status: :unprocessable_entity
  end
end
