#1
SELECT SUM(quantityOnHand) AS antibioticContainers
FROM item
WHERE itemDescription LIKE '%antibiotic%';

#2
SELECT volunteerName
FROM volunteer
WHERE volunteerTelephone NOT LIKE '2%'
  AND TRIM(volunteerName) NOT LIKE '% Jones'
ORDER BY volunteerName;

#3
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON v.volunteerId = a.volunteerId
JOIN task AS t ON a.taskCode = t.taskCode
JOIN task_type AS tt ON t.taskTypeId = tt.taskTypeId
WHERE tt.taskTypeName = 'transporting'
ORDER BY v.volunteerName;

#4
SELECT t.taskDescription
FROM task AS t
LEFT JOIN assignment AS a ON t.taskCode = a.taskCode
WHERE a.volunteerId IS NULL
ORDER BY t.taskCode;

#5
SELECT DISTINCT pt.packageTypeName
FROM package_type AS pt
JOIN package AS p ON pt.packageTypeId = p.packageTypeId
JOIN package_contents AS pc ON p.packageId = pc.packageId
JOIN item AS i ON pc.itemId = i.itemId
WHERE i.itemDescription LIKE '%bottle%'
ORDER BY pt.packageTypeName;

#6
SELECT i.itemDescription
FROM item AS i
LEFT JOIN package_contents AS pc ON i.itemId = pc.itemId
WHERE pc.packageId IS NULL
ORDER BY i.itemDescription;

#7
SELECT DISTINCT t.taskDescription
FROM task AS t
JOIN assignment AS a ON t.taskCode = a.taskCode
JOIN volunteer AS v ON a.volunteerId = v.volunteerId
WHERE TRIM(v.volunteerAddress) LIKE '% NJ'
ORDER BY t.taskDescription;

#8
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON v.volunteerId = a.volunteerId
WHERE a.startDateTime >= '2021-01-01'
  AND a.startDateTime < '2021-07-01'
ORDER BY v.volunteerName;

#9
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON v.volunteerId = a.volunteerId
JOIN task AS t ON a.taskCode = t.taskCode
JOIN task_type AS tt ON t.taskTypeId = tt.taskTypeId
JOIN package AS p ON t.taskCode = p.taskCode
JOIN package_contents AS pc ON p.packageId = pc.packageId
JOIN item AS i ON pc.itemId = i.itemId
WHERE tt.taskTypeName = 'packing'
  AND i.itemDescription LIKE '%spam%'
ORDER BY v.volunteerName;

#10
SELECT DISTINCT i.itemDescription
FROM item AS i
JOIN package_contents AS pc ON i.itemId = pc.itemId
WHERE i.itemValue * pc.itemQuantity = 100
ORDER BY i.itemDescription;

#11
SELECT ts.taskStatusName, COUNT(DISTINCT a.volunteerId) AS volunteerCount
FROM task_status AS ts
LEFT JOIN task AS t ON ts.taskStatusId = t.taskStatusId
LEFT JOIN assignment AS a ON t.taskCode = a.taskCode
GROUP BY ts.taskStatusId, ts.taskStatusName
ORDER BY volunteerCount DESC, ts.taskStatusName;

#12
SELECT taskCode, SUM(packageWeight) AS totalWeight
FROM package
GROUP BY taskCode
ORDER BY totalWeight DESC, taskCode
LIMIT 1;

#13
SELECT COUNT(*) AS nonPackingTaskCount
FROM task AS t
JOIN task_type AS tt ON t.taskTypeId = tt.taskTypeId
WHERE tt.taskTypeName <> 'packing';

#14
SELECT i.itemDescription
FROM item AS i
JOIN package_contents AS pc ON i.itemId = pc.itemId
JOIN package AS p ON pc.packageId = p.packageId
JOIN task AS t ON p.taskCode = t.taskCode
JOIN task_type AS tt ON t.taskTypeId = tt.taskTypeId
LEFT JOIN assignment AS a ON t.taskCode = a.taskCode
WHERE tt.taskTypeName = 'packing'
GROUP BY i.itemId, i.itemDescription
HAVING COUNT(DISTINCT a.volunteerId) < 3
ORDER BY i.itemDescription;

#15
SELECT p.packageId, SUM(i.itemValue * pc.itemQuantity) AS totalValue
FROM package AS p
JOIN package_contents AS pc ON p.packageId = pc.packageId
JOIN item AS i ON pc.itemId = i.itemId
GROUP BY p.packageId
HAVING SUM(i.itemValue * pc.itemQuantity) > 100
ORDER BY totalValue ASC, p.packageId;
