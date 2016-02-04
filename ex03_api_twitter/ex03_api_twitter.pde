import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

Twitter twitter;
Trends trends;

void setup()
{
  size(800, 600);

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("*****YOUR-KEY-HERE******");
  cb.setOAuthConsumerSecret("*************YOUR-KEY-HERE*************");
  cb.setOAuthAccessToken("*************YOUR-KEY-HERE***************");
  cb.setOAuthAccessTokenSecret("**********YOUR-KEY-HERE***************");
  TwitterFactory tf = new TwitterFactory(cb.build());

  twitter = tf.getInstance();

  getBcnTrends();

  thread("refreshTweets");
}

void draw()
{
  fill(0);
  rect(0, 0, width, height); 

  fill(200);
  for (int i = 0; i < trends.getTrends().length; i++) {
    if (i < 25)
      text(trends.getTrends()[i].getName(), 20, 10 + height / 30 * i, 300, 200);
    else
      text(trends.getTrends()[i].getName(), 200, 10 + height / 30 * (i-25), 300, 200);
  } 

  delay(1000);
}

void getBcnTrends()
{
  try
  {
    trends = twitter.getPlaceTrends(753692); //este es el WOEID de BCN!!
  }
  catch (TwitterException te)
  {
    System.out.println("Failed to search tweets: " + te.getMessage());
    System.exit(-1);
  }
}

void refreshTweets()
{
  while (true)
  {
    getBcnTrends();

    println("Updated Trends");
    println(trends.getTrends().length);

    delay(100000);
  }
}