module Api
  module V1
    class SongTracksController < ApplicationController
      before_action :authenticate!, only: [:create, :update, :destroy]
      load_and_authorize_resource

      def index
        render json: @song_tracks, serializer: ActiveModel::ArraySerializer, each_serializer: SongTrackSerializer
      end

      def show
        render json: @song_track, serializer: SongTrackSerializer
      end

      def create
        if @song_track.save
          render json: @song_track, status: 200, location: [:api, @song_track]
        else
          render json: { errors: @song_track.errors }, status: 422
        end
      end

      def destroy
        if @song_track.destroy
          head 200
        else
          head 422
        end
      end

      def update
        if @song_track.update(song_track_params)
          render json: @song_track, status: 200, location: [:api, @song_track]
        else
          render json: { errors: @song_track.errors }, status: 422
        end
      end

      private

      def song_track_params
        params.require(:song_track).permit(:name, :song_id, :user_id)
      end
    end
  end
end
