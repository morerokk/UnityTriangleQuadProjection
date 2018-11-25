# What is this?
This is a proof of concept. It's a mesh and a shader that can "project" a quad between two anchor points.
For example, you could use this in a VR environment to project an effect on a quad between your hands.

# How do I use it?
The triangle mesh has two bones, a left anchor and right anchor. Moving any of these bones will change the quad's shape.

Recommended setup for VRChat:
- Put triangle prefab on Right wrist.
- Forcibly reparent the Left Anchor bone to your Left wrist. This will break the prefab instance, but that's okay.
- Move the left and right anchor bones as you see fit.

Special thanks to Dj Lukis.LT#4639 on Discord for posting a proof of concept video, and sharing the bone reparenting trick!
