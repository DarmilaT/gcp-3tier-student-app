import React, { useState } from "react";
import "./StudentUI.css"; // Custom CSS file

export default function StudentForm() {
  const [name, setName] = useState("");
  const [rollNumber, setRollNumber] = useState("");
  const [className, setClassName] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const res = await fetch(
        "https://backend-app-442031880606.asia-south2.run.app/students",
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            name,
            roll_number: rollNumber,
            class_name: className,
          }),
        }
      );

      if (!res.ok) throw new Error("Failed to add student");

      alert("✅ Student added successfully!");
      setName("");
      setRollNumber("");
      setClassName("");
    } catch (err) {
      console.error(err);
      alert("❌ Something went wrong while submitting.");
    }
  };

  return (
    <form onSubmit={handleSubmit} className="card form-card">
      <h2 className="form-title">📥 Add New Student</h2>

      <label>Name</label>
      <input
        type="text"
        value={name}
        placeholder="Enter name"
        onChange={(e) => setName(e.target.value)}
        required
      />

      <label>Roll Number</label>
      <input
        type="text"
        value={rollNumber}
        placeholder="Enter roll number"
        onChange={(e) => setRollNumber(e.target.value)}
        required
      />

      <label>Class Name</label>
      <input
        type="text"
        value={className}
        placeholder="Enter class name"
        onChange={(e) => setClassName(e.target.value)}
        required
      />

      <button type="submit" className="submit-btn">
        Add Student
      </button>
    </form>
  );
}
