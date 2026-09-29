require_relative "../lib/player"

RSpec.describe Player do
  describe "#initialize" do
    it "creates a player with a name" do
      player = Player.new("Kate", "X")

      expect(player.name).to eq("Kate")
    end

    it "creates a player with a game piece" do
      player = Player.new("Kate", "X")

      expect(player.piece).to eq("X")
    end
  end
end