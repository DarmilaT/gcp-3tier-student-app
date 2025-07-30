// App.js
import React from "react";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import StudentForm from "./StudentForm";
import StudentList from "./StudentList";
import "./StudentUI.css";

function App() {
  return (
    <Router>
      <nav className="navbar">
        <Link to="/form" className="nav-link">
          ➕ Add Student
        </Link>
        <Link to="/list" className="nav-link">
          📋 View Students
        </Link>
      </nav>
      <Routes>
        <Route path="/" element={<StudentList />} />
        <Route path="/form" element={<StudentForm />} />
        <Route path="/list" element={<StudentList />} />
      </Routes>
    </Router>
  );
}

export default App;
