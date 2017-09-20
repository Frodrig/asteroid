
class SoundManager {
  AudioSample shot;
  AudioSample smallAsteroidExplosion;
  AudioSample mediumAsteroidExplosion;
  AudioSample bigAsteroidExplosion;
  AudioPlayer normalOvniPlayer;
  AudioPlayer eliteOvniPlayer;
  AudioPlayer thrust;

  SoundManager() {
    shot = minim.loadSample( "fire.wav", 512);
    smallAsteroidExplosion = minim.loadSample( "bangSmall.wav", 512);
    mediumAsteroidExplosion = minim.loadSample( "bangMedium.wav", 512);
    bigAsteroidExplosion = minim.loadSample( "bangLarge.wav", 512);
    normalOvniPlayer = minim.loadFile("saucerBig.wav");
    eliteOvniPlayer = minim.loadFile("saucerSmall.wav");
    thrust = minim.loadFile("thrust.wav");
  }

  public void playShootSound() {
    shot.trigger();
  }

  public void playSmallAsteroidExplosion() {
    smallAsteroidExplosion.trigger();
  }

  public void playMediumAsteroidExplosion() {
    mediumAsteroidExplosion.trigger();
  }

  public void playBigAsteroidExplosion() {
    bigAsteroidExplosion.trigger();
  }

  public void beginPlayingNormalOvni() {
    normalOvniPlayer.loop();
  }

  public void endPlayingNormalOvni() {
    normalOvniPlayer.pause();
    normalOvniPlayer.rewind();
  }

  public void beginPlayingEliteOvni() {
    eliteOvniPlayer.loop();
  }

  public void endPlayingEliteOvni() {
    eliteOvniPlayer.pause();
    eliteOvniPlayer.rewind();
  }

  public void beginPlayingBoost() {
    if (!thrust.isPlaying()) {
      //thrust.loop();
    }
  }

  public void endPlayingBoost() {
   // if (thrust.isPlaying()) {
      //thrust.pause();
      //thrust.rewind();
    //}
  }
}