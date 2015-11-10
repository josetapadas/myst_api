module Api
  module V1
    class SongsController < ApplicationController
      before_action :authenticate!, only: [:create, :update, :destroy]
      load_and_authorize_resource

      def index
        render json: @songs, serializer: ActiveModel::ArraySerializer, each_serializer: SongSerializer
      end

      def show
        render json: @song, serializer: SongSerializer
      end

      def create
        @song = current_user.songs.build(song_params)

        if @song.save
          render json: @song, status: 200, location: [:api, @song]
        else
          render json: { errors: @song.errors }, status: 422
        end
      end

      def destroy
        if @song.destroy
          head 200
        else
          head 422
        end
      end

      def update
        if @song.update(song_params)
          render json: @song, status: 200, location: [:api, @song]
        else
          render json: { errors: @song.errors }, status: 422
        end
      end

      private

      def song_params
        params.require(:song).permit(:title)
      end
    end
  end
end
