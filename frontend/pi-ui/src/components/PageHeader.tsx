import React, { type ReactNode } from "react";

interface PageHeaderProps {
  title: string;
  icon: ReactNode;
}

const PageHeader: React.FC<PageHeaderProps> = ({ title, icon }) => {
  return (
    <div className="page-header desktop-only-header">
      <div className="page-header-icon">
        {icon}
      </div>
      <h1>{title}</h1>
      <div className="page-header-line"></div>
    </div>
  );
};

export default PageHeader;
