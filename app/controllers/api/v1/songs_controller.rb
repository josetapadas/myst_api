module Api
  module V1
    class SongsController < ApplicationController
      def index
        @songs = Song.all
        render json: @songs, serializer: ActiveModel::ArraySerializer, each_serializer: SongSerializer
      end
    end
  end
end
