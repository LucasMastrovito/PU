#============================================================================== 
# ■ Scene_VS_BARRE
# Pokemon Script Project - Zohran 
# 02/12/2012
# Pokemon version Temporelle - Dark Ray
# 05/12/2012 : Adaptation pour PSP v0.7
#
# Pour appeler ce script :
# lancer_barre_vs("image", reverse)
#
# Où image = nom du fichier dans le dossier Graphics/VS Barre sans l'extension
# Où reverse = false (image originale), ou true (image inversée horizontalement)
#
#----------------------------------------------------------------------------- 
# Amélioré par Damien Linux
# 21/11/2020
#----------------------------------------------------------------------------- 
# Scène à ne pas modifier de préférence, sauf si vous savez ce que vous faites 
#----------------------------------------------------------------------------- 
class Interpreter
  def lancer_barre_vs(face, reverse)
    $scene = Scene_Vs_Barre.new(face, reverse)
  end
end
  
class Scene_Vs_Barre
  
  DATA_AUDIO_VS = {
    :vs_choc => "Audio/SE/VS Choc.wav",
    :vs => "Audio/SE/VS.wav"
  }
  
  DATA_IMAGE_VS = {
    :contour => "Graphics/Pictures/vs/Contour.png",
    :vs => "Graphics/Pictures/vs/VS.png",
    :joueur => "Graphics/Pictures/vs/Joueur.png",
    :ennemi => "Graphics/Pictures/vs/Ennemi.png",
    :action => "Graphics/Pictures/vs/Action",
    :sprite_fille => "Graphics/Pictures/vs/heroine.png",
    :sprite_gars => "Graphics/Pictures/vs/heros.png"
  }
  
  DATA_BATTLE_VS = {
    #-1 => {
    # :audio => "Audio/ME/battle_jingle.mid",
    # :wait => 30
    #}
  }

  def initialize(face, reverse)
    @face = face
    @reverse = reverse
  end

  def main
    # Jingles
    @index = $game_variables[CONFIGURATION_BATTLE_TRAINER]
    if DATA_BATTLE_VS[@index]
      Audio.me_play(DATA_BATTLE_VS[@index][:audio], 80)
    elsif DATA_BATTLE_VS[-1]
      @index = -1
      Audio.me_play(DATA_BATTLE_VS[-1][:audio], 80)
    else
      @index = nil
    end

    @spriteset = Spriteset_Map.new

    @cadre_joueur = Sprite.new
    @cadre_joueur.bitmap = Bitmap.new(DATA_IMAGE_VS[:contour])
    @cadre_joueur.x = -626
    @cadre_joueur.y = 26 + 192 - 75
    @cadre_joueur.z = 5000

    @cadre_ennemi = Sprite.new
    @cadre_ennemi.bitmap = Bitmap.new(DATA_IMAGE_VS[:contour])
    @cadre_ennemi.x = 676
    @cadre_ennemi.y = 26 + 192 - 75
    @cadre_ennemi.z = 5000

    @vs = Sprite.new
    @vs.bitmap = Bitmap.new(DATA_IMAGE_VS[:vs])
    @vs.x = 240
    @vs.y = 170
    @vs.visible = false
    @vs.z = 6000

    @joueur = Sprite.new
    @joueur.bitmap = Bitmap.new(DATA_IMAGE_VS[:joueur])
    @joueur.x = -626
    @joueur.y = 156
    @joueur.z = 5001

    @ennemi = Sprite.new
    @ennemi.bitmap = Bitmap.new(DATA_IMAGE_VS[:ennemi])
    @ennemi.x = 676*2 - @ennemi.bitmap.width
    @ennemi.y = 157 
    @ennemi.z = 5001

    @viewport_joueur = Viewport.new(
      -64, 
      157, 
      @joueur.bitmap.width, 
      @joueur.bitmap.height)
    @viewport_joueur.z = 5002
    @action_joueur = Plane.new(@viewport_joueur)
    @action_joueur.bitmap = Bitmap.new(DATA_IMAGE_VS[:action])
    @action_joueur.visible = false
    @action_joueur.z = 5002

    @viewport_ennemi = Viewport.new(
      304,
      157, 
      @ennemi.bitmap.width, 
      @ennemi.bitmap.height)
    @viewport_ennemi.z = 5002
    @action_ennemi = Plane.new(@viewport_ennemi)
    @action_ennemi.bitmap = Bitmap.new(DATA_IMAGE_VS[:action])
    @action_ennemi.visible = false
    @action_ennemi.z = 5002

    @visage_joueur = Sprite.new

    if $game_switches[FILLE]
      @visage_joueur.bitmap = Bitmap.new(DATA_IMAGE_VS[:sprite_fille])
    else
      @visage_joueur.bitmap = Bitmap.new(DATA_IMAGE_VS[:sprite_gars])
    end

    # Sinon
    @visage_joueur.x = -576
    @visage_joueur.y = 26 + 192 - 75 + 14
    @visage_joueur.z = 5003

    @visage_ennemi = Sprite.new
    @visage_ennemi.bitmap = Bitmap.new("Graphics/Pictures/vs/" + @face)
    @visage_ennemi.x = 602*2 - @visage_ennemi.bitmap.width
    @visage_ennemi.y = 26 + 192 - 75 + 14
    @visage_ennemi.color = Color.new(0, 0, 0, 255)
    @visage_ennemi.z = 5003
    @visage_ennemi.mirror = @reverse

    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @spriteset.dispose
    @cadre_joueur.dispose if @cadre_joueur != nil
    @cadre_ennemi.dispose if @cadre_ennemi != nil
    @vs.dispose if @vs != nil
    @joueur.dispose if @joueur != nil
    @ennemi.dispose if @ennemi != nil
    @action_joueur.dispose if @action_joueur != nil
    @action_ennemi.dispose if @action_ennemi != nil
    @visage_joueur.dispose if @visage_joueur != nil
    @visage_ennemi.dispose if @visage_ennemi != nil
  end

  def update
    loop do
      @cadre_joueur.x += 32
      @cadre_ennemi.x -= 32
      @joueur.x += 32
      @ennemi.x -= 36
      Graphics.update
      if @joueur.x >= -28
        @joueur.x = -28
        @ennemi.x = 660 - @ennemi.bitmap.width
        Graphics.update
        break
      end
    end

    Audio.se_play(DATA_AUDIO_VS[:vs_choc])

    loop do
      @visage_joueur.x += 32
      @visage_ennemi.x -= 32
      Graphics.update
      if @visage_joueur.x >= 26
        @visage_joueur.x = 0
        @visage_ennemi.x = 628 - @visage_ennemi.bitmap.width
        @visage_ennemi.color = Color.new(255, 255, 255, 0)
        Graphics.update
        break
      end
    end

    @vs.visible = true
    @action_joueur.visible = true
    @action_ennemi.visible = true

    Audio.se_play(DATA_AUDIO_VS[:vs])
    
    i = 0
    i1 = 0
    frame_wait  = (@index ? DATA_BATTLE_VS[@index][:wait] : 30)

    loop do
      i += 1
      i1 += 1
      
      if i == 8
        i = 0
      end
      
      @action_joueur.ox -= 15
      @action_ennemi.ox += 15
      
       case i
       when 0, 6
        @vs.x += 1
      when 1, 7
        @vs.y += 1
      when 2, 4
        @vs.x -= 1
      when 3, 5
        @vs.y -= 1
      end
      
      Graphics.update
      if i1 >= frame_wait
        @vs.x = 240
        @vs.y = 26 + 192 + 27
        Graphics.update
        break
      end
    end
    
    i = 0
    
    loop do
      i += 1
      @vs.x -= 128
      @vs.y -= 80
      @vs.zoom_x += 2
      @vs.zoom_y += 2
      Graphics.update
      if i >= 30
        Graphics.update
        @fin = true
        break
      end
    end
    $scene = Scene_Map.new
end

  def wait(frame)
    i = 0
    loop do
      i += 1
      Graphics.update
      if i >= frame
        break
      end
    end
  end
end