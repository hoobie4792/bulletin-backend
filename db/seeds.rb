# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
print 'Destroying data...'
Notification.destroy_all
Follow.destroy_all
Participant.destroy_all
Message.destroy_all
Conversation.destroy_all
User.destroy_all
puts 'Data destroyed'

print 'Creating users...'
brandon = User.create(email: 'brandon@brandon.com', username: 'brandon', password: '123', bio: 'Always doing something', is_private: false)
robert = User.create(email: 'robert@robert.com', username: 'robert', password: '123', bio: 'Ducking in a shed', is_private: false)
geoffrey = User.create(email: 'geoffrey@geoffrey.com', username: 'geoffrey', password: '123', bio: 'Im stupendous', is_private: true)
puts 'Users created'

print 'Creating follows....'
Follow.create(follower: brandon, followed: robert)
Follow.create(follower: brandon, followed: geoffrey)
Follow.create(follower: robert, followed: geoffrey)
Follow.create(follower: geoffrey, followed: brandon)
puts 'Folows created'

print 'Creating notifications...'
Notification.create(content: 'You got mail', user: brandon)
puts 'Notifications created'

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