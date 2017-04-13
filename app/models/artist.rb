class Artist < ActiveRecord::Base
  has_many(
    :albums,
    class_name: "Album",
    foreign_key: :artist_id,
    primary_key: :id
  )

  def n_plus_one_tracks
    albums = self.albums
    tracks_count = {}
    albums.each do |album|
      tracks_count[album.title] = album.tracks.length
    end

    tracks_count
  end

  def better_tracks_query
    album_counts = albums
                   .joins('JOIN tracks ON albums.id = tracks.album_id')
                   .select('albums.title, COUNT(tracks.id) AS tracks_count')
                   .group('albums.title')
                   .order('tracks_count DESC')
    tracks_count = {}
    album_counts.each do |album|
      tracks_count[album.title] = album.tracks_count
    end

    tracks_count
  end
end
