package de.uniba.dsg.jaxrs.resources;

import java.io.IOException;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.QueryParam;

import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.model_objects.specification.Paging;
import com.wrapper.spotify.model_objects.specification.Track;
import com.wrapper.spotify.requests.data.search.simplified.SearchTracksRequest;

import de.uniba.dsg.CustomSpotifyApi;
import de.uniba.dsg.interfaces.SearchTrackApi;
import de.uniba.dsg.jaxrs.exceptions.ClientRequestException;
import de.uniba.dsg.jaxrs.exceptions.RemoteApiException;
import de.uniba.dsg.jaxrs.exceptions.ResourceNotFoundException;
import de.uniba.dsg.models.ErrorMessage;
import de.uniba.dsg.models.TrackModel;

@Path("api/tracks/search")
public class SearchTrackResource implements SearchTrackApi{
	@Override
	@GET
	public TrackModel searchTracks(@QueryParam("title") String songTitle,@QueryParam("artist")String artist){
		System.out.println("Service requested");
		if (songTitle == null && artist == null) {
			throw new ClientRequestException(new ErrorMessage("Required query parameter is missing: artist"));
		}
		TrackModel trackModel = new TrackModel();
		SearchTracksRequest searchTracksRequest = CustomSpotifyApi.getInstance().searchTracks(artist).build();
		try
		{
			Paging<Track> trackPaging = searchTracksRequest.execute();
			Track[] tracks = trackPaging.getItems();
			
			if (tracks != null && tracks.length == 0) {
				throw new ResourceNotFoundException(new ErrorMessage(String.format("No matching tracks found for song title : %s", songTitle)));
			}			
			
			for (Track track : tracks) {
				if(track.getName().equals(songTitle)) {
					trackModel.setId(track.getId());
					trackModel.setSongTitle(track.getName());
					trackModel.setArtistName(artist);
					break;
				}
			}			
		}catch (SpotifyWebApiException | IOException e) {
			throw new RemoteApiException(new ErrorMessage(e.getMessage()));
		}
		return trackModel;
	}
}
