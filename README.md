# Godot UI Template

This is a Godot 4.2 project, created with the goal to facilitate onboarding a basic UI setup for a simple game. Use it as you wish.

## How to use it

Download from repository https://github.com/marinho/godot-ui-template and copy folder "ui" to your game project. Then adapt it to whatever is your need.

You can either use the nodes and scripts as they are, modify them to your game or - the most recommended when possible - keep them as they are and extend your own classes by using them. This is because of Single Reponsibility Principle and separation of concerns.

## AutoLoads

Most features in this repository depend in one or other way on some of the autoload nodes to be enabled in the project. They are listed below.

### FreezeManager

Manages how the game freezes processes, usually necessary for pausing the game or taking physics away while doing scene transitions or cut scenes.

Freezing applies only to nodes with [Process Mode](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-property-process-mode) being pausable. The UI nodes of this repository are mostly non pausable, due to their nature.

#### Methods

| Name                                      | Description                                              |
| ----------------------------------------- | -------------------------------------------------------- |
| void **set_freezed**(to_be_freezed: bool) | Set a boolean value to define if game should be freezed. |

#### Signals

| Name          | Description                                |
| ------------- | ------------------------------------------ |
| **freezed**   | Triggered after the tree is set paused     |
| **unfreezed** | Triggered after the tree is set not paused |

### GameManager

Very basic game management singleton, used to keep what's current game and scene and changing to another one.

#### Properties

| Name                          | Description                                                                                                      |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| int **current_game_id**       | ID of current game as saved with GamePersistence. Default: `-1`                                                  |
| String **current_scene_path** | Path to currently loaded scene                                                                                   |
| String **entry_scene_path**   | Path to first scene when the game i started (i.e. entry menu). Default: `"res://ui/entry_menu/entry-scene.tscn"` |

#### Methods

| Name                                         | Description                                                                                          |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| void **set_current_game**(new_game: int)     | Set the ID of currently loaded game                                                                  |
| void **load_scene**(scene_file_path: String) | Loads a scene by its path, using SceneTransition                                                     |
| void **load_entry_scene**()                  | Returns back to entry scene - main difference to **load_scene** is that it doesn't activate InGameUI |

### GamePersistence

Responsible for file management for game states.

#### Properties

| Name                 | Description                                                                                                                                                                                 |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| String **file_name** | File where game state is saved. [More information in here](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#accessing-persistent-user-data-user). Default: `"game.json"` |

#### Methods

| Name                                                                            | Description                                                                                                                                                                                                                                               |
| ------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Dictionary **\_read_file_as_json**()                                            | Just read JSON file a return as a dictionary                                                                                                                                                                                                              |
| void **save_json_to_file**(json: Dictionary)                                    | Save a dictionary into the JSON file                                                                                                                                                                                                                      |
| Dictionary[] **get_saved_games**()                                              | Returns a list of saved games from JSON file                                                                                                                                                                                                              |
| Dictionary **save_new_game**(first_scene_path: String)                          | Create a new game with default values and return it                                                                                                                                                                                                       |
| Dictionary **load_game**(game_id: int)                                          | Load a saved game by its ID                                                                                                                                                                                                                               |
| Dictionary **\_override_dict**(original_dict: Dictionary, new_dict: Dictionary) | Works like [Dictionary.merge](https://docs.godotengine.org/en/stable/classes/class_dictionary.html#class-dictionary-method-merge), except that a value that is a dictionary won't replace the whole value but just the keys present in the new dictionary |

### GameSaver

Responsible for collecting current game player state and then saving it using GamePersistence. Automatic savings are possible, but disabled by default, as some games don't have it.

#### Properties

| Name                 | Description                                                                                            |
| -------------------- | ------------------------------------------------------------------------------------------------------ |
| bool **auto_saving** | When enabled, it will save current game based on the Timer node in `game_saver.tscn`. Default: `false` |

#### Methods

| Name                         | Description                                                                                           |
| ---------------------------- | ----------------------------------------------------------------------------------------------------- |
| void **save_player_state**() | Collects current game state, such as current scene and player position and save using GamePersistence |

#### Signals

| Name             | Description                    |
| ---------------- | ------------------------------ |
| **before_saved** | Triggered before game is saved |
| **after_saved**  | Triggered after game is saved  |

### SceneTransition

Responsible for a smooth transition from a scene to another, with a loading animation in between.

#### Methods

| Name                                  | Description                                                                   |
| ------------------------------------- | ----------------------------------------------------------------------------- |
| void **change_scene**(target: String) | Does a transition from current to a new scene, using FreezeManager in between |

#### Signals

| Name                   | Description                                         |
| ---------------------- | --------------------------------------------------- |
| **after_scene_change** | Triggered after a new scene is loaded to be current |
