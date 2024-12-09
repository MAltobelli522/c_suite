from agents.ceo_agent import CEOAgent
from agents.cto_agent import CTOAgent
from engine.turn_manager import TurnManager
from engine.memory_manager import MemoryManager
from engine.synthesis_module import SynthesisModule
from engine.user_interaction import UserInteraction

# Initialize agents
agents = [CEOAgent(), CTOAgent()]  # Add other agents as needed

# Initialize system components
turn_manager = TurnManager(agents)
memory_manager = MemoryManager()

# Start session
print("Describe your problem:")
user_problem = input("> ")
memory_manager.update_memory(user_problem)

for _ in range(5):  # Run 5 turns
    context = memory_manager.get_context()
    response = turn_manager.process_turn(context)
    print(f"{turn_manager.agents[turn_manager.current_index - 1].name}: {response}")
    memory_manager.update_memory(response)

    print("Do you want to add a comment or skip? (comment/skip):")
    action = input("> ").strip().lower()
    if action == "comment":
        print("Enter your comment:")
        user_input = input("> ")
        UserInteraction.process_user_input(user_input, memory_manager)
    elif action == "skip":
        continue

# Synthesize results
summary = SynthesisModule.synthesize(turn_manager.history)
print(summary)
