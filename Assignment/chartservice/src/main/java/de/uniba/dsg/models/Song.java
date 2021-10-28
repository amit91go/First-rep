package de.uniba.dsg.models;

/**
 * TODO:
 * Song attributes should be
 * - title:String
 * - artist:String (possibly multiple artists concatenated with ", ")
 * - duration:double (in seconds)
 */
public class Song {

	String id;
	String title;
	String artists;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getArtists() {
		return artists;
	}
	public void setArtists(String artists) {
		this.artists = artists;
	}
	
}