require_relative './seed_helpers/create_news_sources'
require_relative './seed_helpers/create_interests'

print 'Destroying data...'
Notification.destroy_all
Follow.destroy_all
Participant.destroy_all
Message.destroy_all
Conversation.destroy_all
PostTag.destroy_all
Comment.destroy_all
Like.destroy_all
Share.destroy_all
Post.destroy_all
Tag.destroy_all
UserNewsSource.destroy_all
UserInterest.destroy_all
NewsSource.destroy_all
Interest.destroy_all
User.destroy_all
puts 'Data destroyed'

print 'Creating users...'
brandon = User.create(email: 'brandon@brandon.com', username: 'brandon', password: '123', bio: 'Always doing something', is_private: false)
robert = User.create(email: 'robert@robert.com', username: 'robert', password: '123', bio: 'Ducking in a shed', is_private: false)
geoffrey = User.create(email: 'geoffrey@geoffrey.com', username: 'geoffrey', password: '123', bio: 'Im stupendous', is_private: true)
puts 'Users created'

print 'Creating conversations...'
convo1 = Conversation.create
convo2 = Conversation.create
convo3 = Conversation.create
puts 'Conversations created'

print 'Creating participants...'
Participant.create(conversation: convo1, user: brandon)
Participant.create(conversation: convo1, user: robert)
Participant.create(conversation: convo2, user: brandon)
Participant.create(conversation: convo2, user: geoffrey)
Participant.create(conversation: convo3, user: brandon)
Participant.create(conversation: convo3, user: robert)
Participant.create(conversation: convo3, user: geoffrey)
puts 'Participants created'

print 'Creating messages...'
Message.create(conversation: convo1, user: brandon, content: 'Hi Robert')
Message.create(conversation: convo1, user: robert, content: 'Hi Brandon. What are you up to?')
Message.create(conversation: convo1, user: brandon, content: 'Just messing around')
Message.create(conversation: convo2, user: robert, content: 'Hi Geoffrey')
Message.create(conversation: convo2, user: geoffrey, content: 'I AM STUPENDOUS')
Message.create(conversation: convo2, user: robert, content: 'Ok. Sounds good')
Message.create(conversation: convo3, user: brandon, content: 'Hey guys')
Message.create(conversation: convo3, user: robert, content: 'Hello')
Message.create(conversation: convo3, user: geoffrey, content: 'I AM STUPENDOUS. ERRYBODY BOW!')
Message.create(conversation: convo3, user: brandon, content: 'Hmm.')
Message.create(conversation: convo3, user: robert, content: "It's not worth it to fight")
puts 'Messages created'

print 'Creating follows....'
Follow.create(follower: brandon, followed: robert)
Follow.create(follower: brandon, followed: geoffrey)
Follow.create(follower: robert, followed: geoffrey)
Follow.create(follower: geoffrey, followed: brandon)
puts 'Folows created'

print 'Creating notifications...'
Notification.create(content: 'You got mail', user: brandon, notification_type: 'general')
puts 'Notifications created'

print 'Creating posts...'
post1 = Post.create(content: 'I have a lot to do today', user: brandon)
post2 = Post.create(content: 'I have a lot to do today too', user: robert)
post3 = Post.create(content: "I think I'm ahead of the ball", user: geoffrey)
puts 'Posts created'

print 'Creating comments...'
Comment.create(content: 'I hope you get done what you need to', post: post1, user: robert)
Comment.create(content: 'I do too', post: post1, user: geoffrey)
Comment.create(content: 'Oh yikes', post: post2, user: brandon)
Comment.create(content: 'Good luck', post: post2, user: geoffrey)
Comment.create(content: 'Thanks guys', post: post2, user: robert)
Comment.create(content: "That's good news!", post: post3, user: brandon)
Comment.create(content: 'Agreed', post: post3, user: robert)
puts 'Comments created'

print 'Creating likes...'
Like.create(post: post1, user: robert)
Like.create(post: post1, user: geoffrey)
Like.create(post: post2, user: brandon)
Like.create(post: post3, user: robert)
puts 'Likes created'

print 'Creating shares...'
post4 = Post.create(content: 'I wanted to share this', user: brandon)
Share.create(parent_post: post4, shared_post: post2)
post5 = Post.create(content: 'I wanted to share too', user: geoffrey)
Share.create(parent_post: post5, shared_post: post2)
puts 'Shares created'

print 'Creating tags...'
tag1 = Tag.create(name: 'stressed')
tag2 = Tag.create(name: 'Excited')
tag3 = Tag.create(name: 'happy')
PostTag.create(post: post1, tag: tag1)
PostTag.create(post: post1, tag: tag2)
PostTag.create(post: post2, tag: tag1)
PostTag.create(post: post3, tag: tag3)
puts 'Tags created'

print 'Creating news sources...'
create_news_sources
UserNewsSource.create(user: brandon, news_source: NewsSource.first)
UserNewsSource.create(user: robert, news_source: NewsSource.second)
UserNewsSource.create(user: geoffrey, news_source: NewsSource.third)
puts 'News sources created'

print 'Creating interests...'
create_interests
puts 'Interests created'