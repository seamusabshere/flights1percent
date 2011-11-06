class PagesController < ApplicationController
  
  
  def home
      @people = ::Person.all
      @footprints = [
          {:name=>"Paul Allen", :percentage_in_set=> 20, :people_equivalent=> Person.find_by_full_name('Paul Allen').average_people, :emissions_per_year => Person.find_by_full_name('Paul Allen').annualized_emissions, :bio=>%Q{
            Paul Gardner Allen (born January 21, 1953) is an American business magnate, investor, and philanthropist. Allen co-founded Microsoft with Bill Gates. He is also the 57th richest along with Viktor Vekselberg and Gerald Cavendish Grosvenor (& family) who all rank the same with an estimated wealth of $13 billion as of 2011. He is the founder and chairman of Vulcan Inc., which manages his business and philanthropic efforts. Allen also has a multi-billion dollar investment portfolio and owns two professional sports teams.
          }},
          {:name=>"Sergey and Larry", :percentage_in_set=> 10, :people_equivalent=> Person.find_by_full_name('Larry/Sergey').average_people, :emissions_per_year => Person.find_by_full_name('Larry/Sergey').annualized_emissions, :bio=>%Q{
            Sergey Mikhaylovich Brin (born August 21, 1973) and Lawrence "Larry" Page (born March 26, 1973) are computer scientists and internet entrepreneurs who co-founded Google, one of the largest internet companies. As of 2011, each of them had a personal wealth estimated at $16.7 billion.
          }},
          {:name=>"Phil Knight", :percentage_in_set=> 30, :people_equivalent=> Person.find_by_full_name('Phil Knight (Nike)').average_people, :emissions_per_year => Person.find_by_full_name('Phil Knight (Nike)').annualized_emissions, :bio=>%Q{
            Philip Hampson "Phil" Knight (born February 24, 1938) is an American business magnate. He is the co-founder and Chairman of Nike, Inc. He resigned as the company's chief executive officer in 2004, while retaining the position of chairman of the board. As of 2011, Knight's stake in Nike gives him an estimated net worth of US$13.1 billion, making him the 60th richest person in the world and the 22nd richest American.

          }},
          {:name=>"Mark Cuban", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name('Mark Cuban').average_people, :emissions_per_year => Person.find_by_full_name('Mark Cuban').annualized_emissions, :bio=>%Q{
            Mark Cuban (born July 31, 1958) is an American business magnate and investor. He is the owner of the National Basketball Association's Dallas Mavericks, Landmark Theatres, and Magnolia Pictures, and the chairman of the HDTV cable network HDNet. He is also a part-time "shark" investor (i.e.: wealthy entrepreneur who invests in and judges new ideas/inventions) on the television series Shark Tank.

          }},
          {:name=>"Rush Limbaugh", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Rush Limbaugh").average_people, :emissions_per_year => Person.find_by_full_name("Rush Limbaugh").annualized_emissions, :bio=>%Q{
            Rush Hudson Limbaugh III (born January 12, 1951) is an American radio talk show host, conservative political commentator, and an opinion leader in American conservatism. He hosts The Rush Limbaugh Show which is aired throughout the U.S. on Premiere Radio Networks and is the highest-rated talk-radio program in the United States.

          }},
          {:name=>"Oprah Winfrey", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Oprah").average_people, :emissions_per_year => Person.find_by_full_name("Oprah").annualized_emissions, :bio=>%Q{
            Oprah Winfrey (born Oprah Gail Winfrey on January 29, 1954) is an American media proprietor, talk show host, actress, producer and philanthropist. Winfrey is best known for her self-titled, multi-award-winning talk show, which has become the highest-rated program of its kind in history and was nationally syndicated from 1986 to 2011. She has been ranked the richest African American of the 20th century, the greatest black philanthropist in American history, and was for a time the world's only black billionaire.

          }},        
          {:name=>"John Travolta", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("John Travolta").average_people, :emissions_per_year => Person.find_by_full_name("John Travolta").annualized_emissions, :bio=>%Q{
            John Joseph Travolta (born February 18, 1954) is an American actor, dancer and singer. Travolta first became known in the 1970s, after appearing on the television series Welcome Back, Kotter and starring in the box office successes Saturday Night Fever and Grease. Travolta's acting career declined in the early 1980s and continued to deteriorate throughout the remainder of the decade. His career faced a resurgence in the 1990s with his role in Pulp Fiction.

          }},
          {:name=>"Steve Jobs", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Steve Jobs").average_people, :emissions_per_year => Person.find_by_full_name("Steve Jobs").annualized_emissions, :bio=>%Q{
            Steven Paul Jobs (February 24, 1955 - October 5, 2011) was an American businessman and visionary widely recognized (along with his Apple business partner Steve Wozniak) as a charismatic pioneer of the personal computer revolution. He was co-founder, chairman, and chief executive officer of Apple Inc. Jobs was co-founder and previously served as chief executive of Pixar Animation Studios; he became a member of the board of directors of the Walt Disney Company in 2006, following the acquisition of Pixar by Disney.

          }},
          {:name=>"Morgan Freeman", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Morgan Freeman").average_people, :emissions_per_year => Person.find_by_full_name("Morgan Freeman").annualized_emissions, :bio=>%Q{
            Morgan Freeman (born June 1, 1937) is an American actor, film director, aviator and narrator. He is noted for his reserved demeanor and authoritative speaking voice. Freeman has received Academy Award nominations for his performances in Street Smart, Driving Miss Daisy, The Shawshank Redemption and Invictus and won in 2005 for Million Dollar Baby. He has also won a Golden Globe Award and a Screen Actors Guild Award.

          }},
          {:name=>"Jerry Bruckheimer", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Jerry Bruckheimer").average_people, :emissions_per_year => Person.find_by_full_name("Jerry Bruckheimer").annualized_emissions, :bio=>%Q{
            Jerome Leon "Jerry" Bruckheimer (born September 21, 1945) is an American film and television producer. He has achieved great success in the genres of action, drama, and science fiction. His best known television series are CSI: Crime Scene Investigation, CSI: Miami, and CSI: NY. His best known films include Beverly Hills Cop, Top Gun, Black Hawk Down, Pearl Harbor and Pirates of the Caribbean.

          }},
          {:name=>"Mike Bloomberg", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Michael Bloomberg").average_people, :emissions_per_year => Person.find_by_full_name("Michael Bloomberg").annualized_emissions, :bio=>%Q{
            Michael Rubens Bloomberg (born February 14, 1942) is an American business magnate, politician, and philanthropist. Since 2002, he has been the Mayor of New York City and, with a net worth of $19.5 billion in 2011, he is also the 12th-richest person in the United States.[2] He is the founder and eighty-eight percent owner of Bloomberg L.P., a financial news and information services media company.

          }},
          {:name=>"Bob Dylan", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Bob Dylan").average_people, :emissions_per_year => Person.find_by_full_name("Bob Dylan").annualized_emissions, :bio=>%Q{
            Bob Dylan(born Robert Allen Zimmerman on May 24, 1941) is an American singer-songwriter, musician, poet and painter. He has been a major and profoundly influential figure in popular music and culture for five decades.[1][2] Much of his most celebrated work dates from the 1960s when he was an informal chronicler and a seemingly reluctant figurehead of social unrest.

          }},
          {:name=>"Rupert Murdoch", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Rupert Murdoch").average_people, :emissions_per_year => Person.find_by_full_name("Rupert Murdoch").annualized_emissions, :bio=>%Q{
            Keith Rupert Murdoch, AC, KSG (born 11 March 1931) is an Australian American business magnate. He is the founder and Chairman and CEO of News Corporation, the world's second largest media conglomerate.
          }},
          {:name=>"Bill Gates", :percentage_in_set=> 40, :people_equivalent=> Person.find_by_full_name("Bill Gates").average_people, :emissions_per_year => Person.find_by_full_name("Bill Gates").annualized_emissions, :bio=>%Q{
            William Henry "Bill" Gates III (born October 28, 1955) is an American business magnate, investor, philanthropist, author, and former CEO and current chairman of Microsoft, the software company he founded with Paul Allen. He is consistently ranked among the world's wealthiest people and was the wealthiest overall from 1995 to 2009, excluding 2008, when he was ranked third.
          }}      
        ]
  end
end















# [name, percentage in set, people_equivalent, emission/year, bio]
