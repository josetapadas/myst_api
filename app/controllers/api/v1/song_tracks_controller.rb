module Api
  module V1
    class SongTracksController < ApplicationController
      before_action :authenticate!, only: [:create, :update, :destroy]

      def index
        @song_tracks = SongTrack.all
        render json: @song_tracks, serializer: ActiveModel::ArraySerializer, each_serializer: SongTrackSerializer
      end

      def show
        @song_track = SongTrack.find(params[:id])
        render json: @song_track, serializer: SongTrackSerializer
      end

      def create
        if @current_song = current_user.songs.find(params[:song_id])
          @song_track = @current_song.song_tracks.build(song_track_params)

          if @song_track.save
            render json: @song_track, status: 200, location: [:api, @song_track]
          else
            render json: { errors: @song_track.errors }, status: 422
          end
        end
      end

      def destroy
        if @current_song = current_user.songs.find(params[:song_id])
          user_song_track = @current_song.song_tracks.find(params[:id])
          if user_song_track.destroy
            head 200
          else
            head 422
          end
        end
      end

      def update
        if @current_song = current_user.songs.find(params[:song_id])
          current_song_track = @current_song.song_tracks.find(params[:id])
          if current_song_track.update(song_track_params)
            render json: current_song_track, status: 200, location: [:api, current_song_track]
          else
            render json: { errors: current_song_track.errors }, status: 422
          end
        end
      end

      private

      def song_track_params
        params.require(:song_track).permit(:name, :song_id, :user_id)
      end
    end
  end
end
