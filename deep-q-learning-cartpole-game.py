import gym
import random
import numpy as np

from collections import deque

import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout

def create_model(state_size, action_size, training=False, weights_file=None):
	model = Sequential()
	model.add(Dense(24, input_dim=state_size, activation='relu'))

	if training:
		model.add(Dropout(0.2))

	model.add(Dense(24, activation='relu'))
	model.add(Dense(action_size, activation='linear'))
	model.compile(loss='mse', optimizer=keras.optimizers.Adam(lr=0.001))

	if not training:
		model.load_weights(weights_file)

	return model

def main():
	# in order to change time limit or other default configs coming with the game model
	# take a look at: https://github.com/openai/gym/issues/463
	env = gym.make('CartPole-v1')

	state_size = env.observation_space.shape[0]
	action_size = env.action_space.n

	# take 32 random samples from game play history
	batch_size = 32
	game_history = deque(maxlen=3000)

	model = create_model(state_size, action_size, training=True, weights_file="dql.h5")

	epsilon = 1.0
	eps_min = 0.02
	eps_decay = 0.994

	for i in range(1000):
		sc = 0
		state = env.reset()
		state = state.reshape(1, -1) # 1 = row, -1 = if you don't know column size

		for j in range(3000):

			env.render()

			# if rand value is less than epsilon value, do random action so gain experience 
			# (kindda like What happens when you do what, etc)
			if np.random.rand() <= epsilon:
				action = random.randrange(action_size)
			else:
				act_values = model.predict(state)
				action = np.argmax(act_values[0])

			next_state, reward, done, _ = env.step(action)

			if done: 
				reward = -10

			#print("Reward: %.2f" % reward)

			next_state = next_state.reshape(1, -1)

			game_history.append((state, action, reward, next_state, done))

			state = next_state

			if done:
				sc = j
				if j < 300:
					print("Episode: {}/{}, Score: {}, e: {:.2}".format(i, 1000, j, epsilon))
				elif j < 400:
					print("Episode: {}/{}, Score: {}, e: {:.2} ----------- {}".format(i, 1000, j, epsilon, j))
				elif j < 500:
					print("Episode: {}/{}, Score: {}, e: {:.2} +-+-+-+-+-+ {}".format(i, 1000, j, epsilon, j))
				else:
					print("Episode: {}/{}, Score: {}, e: {:.2} +++++++++++ {}".format(i, 1000, j, epsilon, j))
				break

		if len(game_history) > batch_size:
			batch = random.sample(game_history, batch_size)

			for state, action, reward, next_state, done in batch:
				target = reward

				if not done:
					target = (reward * 0.95 * np.amax(model.predict(next_state)[0]))

				target_action = model.predict(state)
				target_action[0][action] = target

				model.fit(state, target_action, epochs=1, verbose=0)

			if epsilon > eps_min:
				epsilon *= eps_decay
 
	model.save_weights('dql4.h5')

if __name__ == '__main__':
	main()