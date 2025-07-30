import React, { useEffect, useState } from "react";
import "./StudentUI.css";

export default function StudentList() {
  const [students, setStudents] = useState([]);

  useEffect(() => {
    fetch("https://backend-app-442031880606.asia-south2.run.app/students")
      .then((res) => res.json())
      .then((data) => setStudents(data))
      .catch((err) => {
        console.error(err);
        alert("❌ Failed to fetch students.");
      });
  }, []);

  return (
    <div className="card list-card">
      <h2 className="form-title">📋 Student List</h2>
      {students.length === 0 ? (
        <p>No students available.</p>
      ) : (
        <div className="table-wrapper">
          <table className="student-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Roll Number</th>
                <th>Class</th>
              </tr>
            </thead>
            <tbody>
              {students.map((s) => (
                <tr key={s.id}>
                  <td>{s.id}</td>
                  <td>{s.name}</td>
                  <td>{s.roll_number}</td>
                  <td>{s.class_name}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
