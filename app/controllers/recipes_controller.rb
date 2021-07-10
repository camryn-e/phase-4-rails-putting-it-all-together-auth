class RecipesController < ApplicationController
    # before_action :authorize
    # skip_before_action :authorize, only: [:index]

    def index
        recipes = Recipe.all
        if session[:user_id]
            render json: recipes, include: :user
        else
            render json: { errors: recipes.errors }, status: :unauthorized
        end

    end
    
    def create
        # if session[:user_id] 
        #     recipe = Recipe.create(recipe_params)
        #     if recipe.valid?
        #         render json: recipe, status: :created
        #     end
        # else
        #     render json: { error: "no auth" }, status: :unauthorized
        # end
        user = User.find(session[:user_id])
        recipe = user.recipes.create(recipe_params)
        # recipe = Recipe.create(recipe_params)
        # recipe.user_id = session[:user_id]
        # byebug
        # puts session[:user_id]
        if recipe.valid?
            render json: recipe, include: :user, status: :created
        elsif session[:user_id]
            render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
        else
            render json: { errors: recipe.errors.full_messages }, status: :unauthorized
        end
        # render json: recipe, include: :user, status: :created

    # rescue ActiveRecord::RecordInvalid => invalid
    #     render json: { errors: invalid.record.errors }, status: :unprocessable_entity
        # else
        #     render json: { errors: recipe.errors }, status: :unauthorized

        # else
        #     render json: { error: "no auth" }, status: :unauthorized
        # end

    end

    private

    def recipe_params
        params.permit(:id, :user_id, :title, :instructions, :minutes_to_complete)
    end

    # def authorize
    #     return render json: { error: "nope" }, status: :unauthorized unless session.include? :user_id
    # end

end
