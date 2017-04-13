class House < ActiveRecord::Base
  has_many(
    :gardeners,
    class_name: "Gardener",
    foreign_key: :house_id,
    primary_key: :id
  )

  has_many(
    :plants,
    through: :gardeners,
    source: :plants
  )

  def n_plus_one_seeds
    plants = self.plants
    seeds = []
    plants.each do |plant|
      seeds << plant.seeds
    end

    seeds
  end

  def better_seeds_query
    Seed.joins(:plant)
        .joins('JOIN gardeners ON plants.gardener_id = gardeners.id')
        .joins('JOIN houses ON gardeners.house_id = houses.id')
        .where('houses.id = ?', id).load
  end
end
