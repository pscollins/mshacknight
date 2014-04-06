import beads.*;
import org.jaudiolibs.beads.*;

// import beads.ugens.*;
// import beads.data.*;
// import beads.core.*;

class LoopingPlayer {
	private SamplePlayer player;
	LoopingPlayer(String path) {
		try {
			Sample sample = new Sample(path);
			// AudioContext context = new AudioContext(
			// 	(new NonrealtimeIO()));
			AudioContext context = new AudioContext();

			player = new SamplePlayer(context, sample);
			player.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);
		} catch (IOException e) {
			println("Something is wrong!!!");
			player = null;
		}
	}

	void play(){
		// player.start();
		player.reTrigger();
	}

	void rewind() {
		player.reset();
	}


	void loop() {
		player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
		player.start();
	}

	void pause() {
		// player.pause();
		player.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS);
	}
}
