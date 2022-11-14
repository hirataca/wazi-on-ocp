# TechGuides
***

To add another topic `xyz`:  

1. Create a new folder `/pages/xyz` to host the markdown pages.  
2. Create a new `xyz_sidebar.yml` definition in `/_data/sidebars` to list the subtopics.  
3. Modify `/_data/sidebars/home_sidebar.yml` to add the new topic.
3. Modify `/_data/topnav.yml` to add the new topic.
4. Modify `/_includes/custom/sidebarconfigs.html` to include the new sidebar definition.  
