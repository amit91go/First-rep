package de.uniba.dsg.interfaces;

import de.uniba.dsg.models.TrackModel;

public interface SearchTrackApi {
	TrackModel searchTracks(String songTitle,String artist) ;
}
