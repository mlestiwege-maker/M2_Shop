import express from "express";
import auth from "../middleware/authMiddleware.js"; // ✅ already updated
import User from "../models/userModel.js"; // ✅ corrected to match your file

const router = express.Router();

// ✅ GET logged-in user's info
router.get("/", auth, async (req, res) => { // ✅ use 'auth' middleware
  try {
    const user = await User.findById(req.user.id).select("-password");
    if (!user) return res.status(404).json({ message: "User not found" });

    res.json({
      _id: user._id,
      fullName: user.fullName,
      email: user.email,
      profilePicUrl: user.profilePicUrl || null,
    });
  } catch (err) {
    console.error("Error fetching user:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

// ✅ UPDATE user profile
router.put("/", auth, async (req, res) => { // ✅ use 'auth' middleware
  const { fullName, password, profilePicUrl } = req.body;

  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    if (fullName) user.fullName = fullName;
    if (password) user.password = password; // hashing handled in pre-save hook
    if (profilePicUrl) user.profilePicUrl = profilePicUrl;

    await user.save();

    res.json({
      _id: user._id,
      fullName: user.fullName,
      email: user.email,
      profilePicUrl: user.profilePicUrl || null,
    });
  } catch (err) {
    console.error("Error updating user:", err.message);
    res.status(500).json({ message: "Server error" });
  }
});

export default router;
