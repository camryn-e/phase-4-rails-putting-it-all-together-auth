class SessionsController < ApplicationController
    # before_action :authorize
    # rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password]) && user.valid?
            session[:user_id] = user.id
            render json: user
        elsif !user&.authenticate(params[:password])
            render json: { error: "No Auth" }, status: :unauthorized
        else
            render json: { errors: user.errors[:username] }, status: :unauthorized
        end
    end

    def destroy
        return render json: { error: "nope" }, status: :unauthorized unless session.include? :user_id
        session.delete :user_id
        head :no_content
    end

    private

    # def authorize
    #     return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    # end

end
