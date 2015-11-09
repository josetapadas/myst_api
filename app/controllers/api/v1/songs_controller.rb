module Api
  module V1
    class SongsController < ApplicationController
      before_action :authenticate!, only: [:create, :update, :destroy]

      def index
        @songs = Song.all
        render json: @songs, serializer: ActiveModel::ArraySerializer, each_serializer: SongSerializer
      end

      def show
        @song = Song.find(params[:id])
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
        user_song = current_user.songs.find(params[:id])
        if user_song.destroy
          head 200
        else
          head 422
        end
      end

      def update
        current_song = current_user.songs.find(params[:id])
        if current_song.update(song_params)
          render json: current_song, status: 200, location: [:api, current_song]
        else
          render json: { errors: current_song.errors }, status: 422
        end
      end

      private

      def song_params
        params.require(:song).permit(:title)
      end
    end
  end
end
